bitmap define hide {{16 16} {
    0x00, 0x00, 0x00, 0x00, 0x04, 0x80, 0x08, 0x40, 0x90, 0x27, 0x60, 0x18,
    0x60, 0x18, 0x90, 0x24, 0x10, 0x23, 0x10, 0x23, 0x90, 0x24, 0x60, 0x18,
    0x60, 0x18, 0x90, 0x27, 0x08, 0x40, 0x04, 0x80}}
        
bitmap define special {{16 16} {
    0x00, 0x00, 0x00, 0x00, 0x04, 0x80, 0x08, 0x40, 0x90, 0x27, 0x60, 0x1b,
    0x60, 0x1b, 0x90, 0x27, 0xf0, 0x3c, 0xf0, 0x3c, 0x90, 0x27, 0x60, 0x1b,
    0x60, 0x1b, 0x90, 0x27, 0x08, 0x40, 0x04, 0x80}}

bitmap define super {{16 16} {
    0x00, 0x00, 0x00, 0x00, 0x7c, 0x08, 0x44, 0x04, 0x44, 0x7e, 0x44, 0x44,
    0x7c, 0x48, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40, 0x7c, 0x40,
    0x44, 0x40, 0x44, 0x7e, 0x44, 0x00, 0x7c, 0x00}}

proc send_id {interp ddwin data} {
    global DDOBJ
    set DDOBJ $data
    drag&drop target $ddwin handle id
}

proc gimme {asdf} {
    return $asdf
}

proc sitecmd {state token} {
    if {$state} {
        $token.l configure -fg OliveDrab
    } else {
        $token.l configure -fg black
    }  
}

proc do_package {probe window token} {
    set local [$probe package: $window]
    if {$local != {}} {
        set label_text [$probe getId: $window]
        if {[winfo children $token] == {}} {
            label $token.l -text $label_text -fg black
            pack $token.l
        } else {
            $token.l config -text $label_text -fg black
        }
        return $local
}   }

proc do_package_arg {probe window arg_num token} {
    set local [$probe package: $window arg: $arg_num]
    if {$local != {}} {
        set label_text [$probe getId: $window arg: $arg_num]
        if {[winfo children $token] == {}} {
            label $token.l -text $label_text -fg black
            pack $token.l
        } else {
            $token.l config -text $label_text -fg black
        }
        return $local
}   }

        
