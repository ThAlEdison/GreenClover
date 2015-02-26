$filename = "C:\WIP\Spiral2.png"
$bw = 3840
$bh = 2160

add-type -AssemblyName System.Drawing
function ColorFromAhsb {
    param($a, $h, $s, $b)

    if(0 -gt $a -or 255 -lt $a) { throw $(new-object System.ArgumentOutOfRangeException("a",$a,"Alpha must be between 0 and 255")) }
    if(0 -gt $h -or 360 -lt $h) { throw $(new-object System.ArgumentOutOfRangeException("h",$h,"Hue must be between 0 and 360")) }
    if(0 -gt $s -or 1 -lt $s) { throw $(new-object System.ArgumentOutOfRangeException("s",$s,"Saturation must be between 0 and 1")) }
    if(0 -gt $b -or 1 -lt $b) { throw $(new-object System.ArgumentOutOfRangeException("b",$b,"Brightness must be between 0 and 1")) }
    if(0 -eq $s) { [System.Drawing.Color]::FromArgb($a, [math]::floor($b * 255), [math]::floor($b * 255), [math]::floor($b * 255)); return }
    if(0.5 -lt $b) { $fMax = $b - ($b*$s) + $s; $fMin = $b + ($b * $s) - $s; }
    else { $fMax = $b + ($b*$s); $fMin = $b - ($b*$s) }
    $iSextant = [math]::floor($h/60.0)
    if( 300 -le $h ) { $h -= 360 }
    $h /= 60.0
    $h -= 2.0 * [math]::floor((($iSextant+1.0) % 6.0) / 2.0)
    if(0 -eq $iSextant % 2.0) { $fMid = $h * ($fMax - $fMin) + $fMin }
    else { $fMid = $fMin - $h * ($fMax - $fMin) }
    Switch( $iSextant ) {
        1 {[System.Drawing.Color]::FromArgb($a,$fMid*255,$fMax*255,$fMin*255); return}
        2 {[System.Drawing.Color]::FromArgb($a,$fMin*255,$fMax*255,$fMid*255); return}
        3 {[System.Drawing.Color]::FromArgb($a,$fMin*255,$fMid*255,$fMax*255); return}
        4 {[System.Drawing.Color]::FromArgb($a,$fMid*255,$fMin*255,$fMax*255); return}
        5 {[System.Drawing.Color]::FromArgb($a,$fMax*255,$fMin*255,$fMid*255); return}
        default {[System.Drawing.Color]::FromArgb($a,$fMax*255,$fMid*255,$fMin*255); return}
    }
}
$hw = [math]::ceiling($bw/2)-1
$hh = [math]::ceiling($bh/2)-1
$bmp = new-object System.Drawing.Bitmap $bw,$bh
$rgr = [System.Drawing.Graphics]::FromImage($bmp)
$brushBlack = [System.Drawing.Brushes]::Black
$brushRed = $brushBlack.Clone()
$brushGreen = $brushBlack.Clone()
$brushBlue = $brushBlack.Clone()
$brushRed.Color = [System.Drawing.Color]::FromArgb(10,255,64,0)
$brushGreen.Color = [System.Drawing.Color]::FromArgb(10,32,255,16)
$brushBlue.Color = [System.Drawing.Color]::FromArgb(10,8,96,255)
$brush = $brushBlue
$c="Blue"
$angle=[Math]::pi
$magnitude=5
$x=0
$y=0
1..194395 | %{
$newx = $x+$magnitude*[Math]::cos($angle)
$newy = $y+$magnitude*[Math]::sin($angle)
$a=$angle%(2*[Math]::pi)
$angle = [Math]::atan2($newy,$newx)+0.5*[Math]::pi
$b=$angle%(2*[Math]::pi)
if($b -gt $a) {
	if($c -eq "Red") { $c = "Green"; $brush = $brushGreen }
	elseif($c -eq "Green") { $c = "Blue"; $brush = $brushBlue }
	elseif($c -eq "Blue") { $c = "Red"; $brush = $brushRed }
}
$rgr.DrawLine($brush,$hw,$hh,$newx+$hw,$newy+$hh)
$rgr.DrawLine($brushBlack,$x+$hw,$y+$hh,$newx+$hw,$newy+$hh)
$x=$newx
$y=$newy
}
$bmp.Save($filename)
