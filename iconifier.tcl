#! /usr/bin/env tclkit8.6
#

# reference: https://wiki.tcl-lang.org/page/Create+starkit.ico+for+windows+starpack

package require Tk

lappend auto_path . lib "C:/tcl/tklib-0.6/modules"
package require ico 

#set exe [lindex $argv 0]
set exe "tclkit.exe"

set img [lindex $argv 0]
#set img "icon_1248-300x300.png"

set icoFile tclkit.ico

pack [ frame .f ] -expand yes -fill both
foreach I [::ico::icons $exe] {
    foreach i [::ico::iconMembers $exe $I] {
        lappend icons {*}$i
    }
}

set pos -1
foreach { n x y bpp } $icons {
  set name [format "icon%s" $n]
  set geom [format %dx%d $x $y]
  set state "$geom @ $bpp"; update idle;

  exec "C:/Program Files/ImageMagick-7.0.8-Q16/convert.exe"  -background transparent -define png:bit-depth=8 -geometry $geom  $img $name.png
  exec "C:/Program Files/ImageMagick-7.0.8-Q16/convert.exe"  $name.png $name.gif

  image create photo $name -file $name.gif

  ::ico::writeIcon $icoFile [incr pos] $bpp $name
    
  grid [ label .f.l${pos} -text $state -width 18 	] -column ${pos} -row 1 -sticky we	
  grid [ label .f.i${pos} -image $name 			] -column ${pos} -row 2 -sticky we	

  file delete $name.png $name.gif
}

set state "DONE\nIcon file is $icoFile"
pack [label .l -text $state -width 18]
pack [button .b -text "EXIT" -command exit] 
