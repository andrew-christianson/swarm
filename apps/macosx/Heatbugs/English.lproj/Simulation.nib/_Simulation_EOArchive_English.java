// _Simulation_EOArchive_English.java
// Generated by EnterpriseObjects palette at Saturday, February 4, 2006 4:57:15 PM America/Indianapolis

import com.webobjects.eoapplication.*;
import com.webobjects.eocontrol.*;
import com.webobjects.eointerface.*;
import com.webobjects.eointerface.swing.*;
import com.webobjects.foundation.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.table.*;
import javax.swing.text.*;

public class _Simulation_EOArchive_English extends com.webobjects.eoapplication.EOArchive {
    com.webobjects.eointerface.swing.EOFrame _eoFrame0;
    com.webobjects.eointerface.swing.EOView _nsCustomView0;
    javax.swing.JPanel _nsView0;

    public _Simulation_EOArchive_English(Object owner, NSDisposableRegistry registry) {
        super(owner, registry);
    }

    protected void _construct() {
        Object owner = _owner();
        EOArchive._ObjectInstantiationDelegate delegate = (owner instanceof EOArchive._ObjectInstantiationDelegate) ? (EOArchive._ObjectInstantiationDelegate)owner : null;
        Object replacement;

        super._construct();


        if ((delegate != null) && ((replacement = delegate.objectForOutletPath(this, "rasterView")) != null)) {
            _nsCustomView0 = (replacement == EOArchive._ObjectInstantiationDelegate.NullObject) ? null : (com.webobjects.eointerface.swing.EOView)replacement;
            _replacedObjects.setObjectForKey(replacement, "_nsCustomView0");
        } else {
            _nsCustomView0 = (com.webobjects.eointerface.swing.EOView)_registered(new com.webobjects.eointerface.swing.EOView(), "View");
        }

        if ((delegate != null) && ((replacement = delegate.objectForOutletPath(this, "rasterWindow")) != null)) {
            _eoFrame0 = (replacement == EOArchive._ObjectInstantiationDelegate.NullObject) ? null : (com.webobjects.eointerface.swing.EOFrame)replacement;
            _replacedObjects.setObjectForKey(replacement, "_eoFrame0");
        } else {
            _eoFrame0 = (com.webobjects.eointerface.swing.EOFrame)_registered(new com.webobjects.eointerface.swing.EOFrame(), "Window");
        }

        _nsView0 = (JPanel)_eoFrame0.getContentPane();
    }

    protected void _awaken() {
        super._awaken();

        if (_replacedObjects.objectForKey("_eoFrame0") == null) {
            _connect(_owner(), _eoFrame0, "rasterWindow");
        }

        if (_replacedObjects.objectForKey("_nsCustomView0") == null) {
            _connect(_owner(), _nsCustomView0, "rasterView");
        }
    }

    protected void _init() {
        super._init();
        if (!(_nsView0.getLayout() instanceof EOViewLayout)) { _nsView0.setLayout(new EOViewLayout()); }
        _nsCustomView0.setSize(440, 320);
        _nsCustomView0.setLocation(13, 14);
        ((EOViewLayout)_nsView0.getLayout()).setAutosizingMask(_nsCustomView0, EOViewLayout.MinYMargin);
        _nsView0.add(_nsCustomView0);

        if (_replacedObjects.objectForKey("_eoFrame0") == null) {
            _nsView0.setSize(466, 348);
            _eoFrame0.setTitle("Window");
            _eoFrame0.setLocation(259, 442);
            _eoFrame0.setSize(466, 348);
        }
    }
}