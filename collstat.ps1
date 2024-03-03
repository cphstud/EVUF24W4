$filesource = "C:\temp\logs\u_ex240124*"
$rapportdir = "c:\temp\rapport\"
$rapportfn = "rapport_"+ (get-date -Format yyyy-M-d_H-mm-s) + ".txt"
$totalpath = $rapportdir + $rapportfn


$base=Get-ChildItem $filesource | Get-Content | Select-String -Pattern "^[^#]" 

for($i=0;$i -lt 16;$i++) {

    $mycollMeth = @()
    $base | ForEach-Object {$res = $_ -split ' ' ; $mycollMeth += $res[$i]} 
    $mycollMeth | Group-Object | Sort-Object Count -Descending | 
    Select-Object Count, Name | Out-File -Append $totalpath

} 
