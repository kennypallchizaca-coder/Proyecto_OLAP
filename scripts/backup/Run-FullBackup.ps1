# PowerShell Wrapper for RMAN Full Backup
# Comisariato Database - Level 0 Backup

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RMAN Full Backup - Comisariato" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$rmanScript = @"
CONNECT TARGET /
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    ALLOCATE CHANNEL ch2 DEVICE TYPE DISK;
    
    BACKUP 
        INCREMENTAL LEVEL 0 
        AS COMPRESSED BACKUPSET
        TAG 'COMISARIATO_FULL_DOM'
        FORMAT 'C:\oracle\backup\rman\COMISARIATO_FULL_%d_%T_%s_%p'
        DATABASE
        PLUS ARCHIVELOG DELETE ALL INPUT;
    
    BACKUP 
        AS COMPRESSED BACKUPSET
        TAG 'COMISARIATO_CTRL_FULL'
        FORMAT 'C:\oracle\backup\rman\COMISARIATO_CTRL_%d_%T_%s_%p'
        CURRENT CONTROLFILE;
    
    BACKUP 
        TAG 'COMISARIATO_SPFILE_FULL'
        FORMAT 'C:\oracle\backup\rman\COMISARIATO_SPFILE_%d_%T_%s_%p'
        SPFILE;
    
    RELEASE CHANNEL ch1;
    RELEASE CHANNEL ch2;
}
LIST BACKUP SUMMARY;
DELETE NOPROMPT OBSOLETE;
EXIT;
"@

$tempFile = [System.IO.Path]::GetTempFileName() + ".rman"
$rmanScript | Out-File -FilePath $tempFile -Encoding ASCII

Write-Host "Executing RMAN backup..." -ForegroundColor Yellow
Write-Host ""

$logFile = "C:\Users\kenny\OneDrive\Documents\PROYECTO-BS\Proyecto_OLAP\scripts\backup\backup_full_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

& rman cmdfile=$tempFile log=$logFile

Remove-Item $tempFile

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Backup Complete!" -ForegroundColor Green  
Write-Host "Log file: $logFile" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
