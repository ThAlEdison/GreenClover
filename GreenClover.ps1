add-type -AssemblyName System.Drawing
$filename = "C:\WIP\Spiral2.png"
$bmp = new-object System.Drawing.Bitmap 3840,2160
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
$rgr.DrawLine($brush,1919,1079,$newx+1919,$newy+1079)
$rgr.DrawLine($brushBlack,$x+1919,$y+1079,$newx+1919,$newy+1079)
$x=$newx
$y=$newy
}
$bmp.Save($filename)
