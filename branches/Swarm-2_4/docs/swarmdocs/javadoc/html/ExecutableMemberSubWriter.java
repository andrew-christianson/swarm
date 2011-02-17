/*
 * @(#)ExecutableMemberSubWriter.java	1.18 98/07/17
 *
 * Copyright 1997, 1998 by Sun Microsystems, Inc.,
 * 901 San Antonio Road, Palo Alto, California, 94303, U.S.A.
 * All rights reserved.
 *
 * This software is the confidential and proprietary information
 * of Sun Microsystems, Inc. ("Confidential Information").  You
 * shall not disclose such Confidential Information and shall use
 * it only in accordance with the terms of the license agreement
 * you entered into with Sun.
 */

// package com.sun.tools.doclets.standard;

import com.sun.tools.doclets.*;
import com.sun.javadoc.*;

/**
 * Print method and constructor info.
 *
 * @author Robert Field
 * @author Atul M Dambalkar
 */
public abstract class ExecutableMemberSubWriter extends AbstractSubWriter {

    ExecutableMemberSubWriter(SubWriterHolderWriter writer) {
        super(writer);
    }

    protected void printSignature(ExecutableMemberDoc member) {
        writer.displayLength = 0;
	writer.pre();
	printModifiers(member);
	bold(member.name());
	printParameters(member);
	printExceptions(member);
	writer.preEnd();
    }
      
    protected void printDeprecatedLink(ProgramElementDoc member) {
        ExecutableMemberDoc emd = (ExecutableMemberDoc)member;
        writer.printClassLink(emd.containingClass(), 
                              emd.name() + emd.signature(),
                              emd.qualifiedName() + emd.flatSignature());
    }
  
    protected void printSummaryLink(ClassDoc cd, ProgramElementDoc member) {
        ExecutableMemberDoc emd = (ExecutableMemberDoc)member;
        ClassDoc mcd = member.containingClass();
        String name = emd.name();
	writer.bold();
        if (mcd != cd) {
            writer.print(mcd.name() + ".");
        }
	writer.printClassLink(mcd, name + emd.signature(), name, false);
	writer.boldEnd();
        writer.displayLength = name.length();
	printParameters(emd);
    }
 
    protected void printInheritedSummaryLink(ClassDoc cd, 
                                             ProgramElementDoc member) {
        ExecutableMemberDoc emd = (ExecutableMemberDoc)member;
        String name = emd.name();
	writer.printClassLink(cd, name + emd.signature(), name, false);
    }    

    protected void printParam(Parameter param) {
        printTypedName(param.type(), param.name());
    }

    protected void printParameters(ExecutableMemberDoc member) {
        int paramstart = 0;
        print('(');
        Parameter[] params = member.parameters();
        String indent = makeSpace(writer.displayLength);
        while (paramstart < params.length) {
            Parameter param = params[paramstart++];
            if (!param.name().startsWith("this$")) {
                printParam(param);
                break;
            }
        }

        for (int i = paramstart; i < params.length; i++) {
            writer.print(',');
            writer.print('\n');
            writer.print(indent);
            printParam(params[i]);
        }
        writer.print(')');
    }

    protected void printExceptions(ExecutableMemberDoc member) {
        ClassDoc[] except = member.thrownExceptions();
        if(except.length > 0) {
            int retlen = getReturnTypeLength(member);
            String indent = makeSpace(modifierString(member).length() + 
                                  member.name().length() + retlen - 4);
            writer.print('\n');
            writer.print(indent);
            writer.print("throws ");
            indent += "       ";
            writer.printClassLink(except[0]);
            for(int i = 1; i < except.length; i++) {
                writer.print(",\n");
                writer.print(indent);
                writer.printClassLink(except[i]);
            }
        }
    }

    protected int getReturnTypeLength(ExecutableMemberDoc member) {
        if (member instanceof MethodDoc) {
            MethodDoc method = (MethodDoc)member;
            Type rettype = method.returnType();
            ClassDoc cd = rettype.asClassDoc();
            if (cd == null) {
                return rettype.typeName().length() + 
                       rettype.dimension().length(); 
            } else {
                return rettype.dimension().length() +
                       ((writer.isCrossClassIncluded(cd))?
                            cd.name().length(): cd.qualifiedName().length());
            }
        } else {   // it's a constructordoc
            return -1;
        }
    }

    protected void printImplementsInfo(MethodDoc method) {
        ClassDoc[] implIntfacs = 
                              method.containingClass().interfaces();
        if (implIntfacs.length > 0) {
            MethodDoc implementedMeth = implementedMethod(method, implIntfacs);
            if (implementedMeth != null) {
                ClassDoc intfac = implementedMeth.containingClass();
                String methlink = "";
                String intfaclink = writer.getClassLink(intfac);
                writer.dt();
                writer.boldText("doclet.Specified_By");
                writer.dd();
                methlink = writer.getDocLink(implementedMeth, 
                                             implementedMeth.name());
                writer.printText("doclet.in_interface", methlink, intfaclink);
            }
        }
    }

    protected ClassDoc implementsMethodInIntfac(MethodDoc method,
                                                ClassDoc[] intfacs) {
        for (int i = 0; i < intfacs.length; i++) {
            MethodDoc[] methods = intfacs[i].methods();
            if (methods.length > 0) {
                for (int j = 0; j < methods.length; j++) {
                    if (methods[j].name().equals(method.name()) &&
                          methods[j].signature().equals(method.signature())) {
                        return intfacs[i];
                    }
                }
            }
        }
        return null;
    }

    protected MethodDoc implementedMethod(MethodDoc method, 
                                          ClassDoc[] intfacs) {
        for (int i = 0; i < intfacs.length; i++) {
            MethodDoc found = findMethod(intfacs[i], method);
            if (found != null) {
                return found;
            }
        }
        return null;
    }

    protected MethodDoc findMethod(ClassDoc cd, MethodDoc method) {
        MethodDoc[] methods = cd.methods();
        for (int i = 0; i < methods.length; i++) {
            if (method.name().equals(methods[i].name()) &&
                   method.signature().equals(methods[i].signature())) {
                return methods[i];
            }
        }
        return null;
    }

    protected void printParamTags(ParamTag[] params) {
        if (params.length > 0) {
            writer.dt();
            writer.boldText("doclet.Parameters");
            for (int i = 0; i < params.length; ++i) {
                ParamTag pt = params[i];
                writer.dd();
                writer.code();
                print(pt.parameterName());
                writer.codeEnd();
                print(" - ");
                writer.printInlineComment(pt);
            }
        }
    }

    protected void printThrowsTags(ThrowsTag[] thrown) {
        if (thrown.length > 0) {
            writer.dt();
            writer.boldText("doclet.Throws");
            for (int i = 0; i < thrown.length; ++i) {
                ThrowsTag tt = thrown[i];
                writer.dd();
                ClassDoc cd = tt.exception();
                if (cd == null) {
                    writer.print(tt.exceptionName());
                } else {
                    writer.printClassLink(cd);
                }
                print(" - ");
                writer.printInlineComment(tt);
            }
        }
    }

    protected String name(ProgramElementDoc member) {
        return member.name() + "()";
    }

    protected void printBodyHtmlEnd(ClassDoc cd) {
    }

    protected void printMember(ProgramElementDoc member) {
        ExecutableMemberDoc emd = (ExecutableMemberDoc)member;
        String name = emd.name();
        writer.anchor(name + emd.signature());
        printHead(emd);
        printSignature(emd);
        printFullComment(emd);
    }
}  
    
    
