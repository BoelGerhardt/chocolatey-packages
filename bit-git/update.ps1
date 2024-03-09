﻿import-module au
$releases = "https://github.com/chriswalz/bit/releases"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(URL\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
      "(Url64bit\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
      "(CheckSum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(CheckSum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      "(CheckSumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(CheckSumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

# https://github.com/chriswalz/bit/releases/download/v1.1.2/bit_1.1.2_windows_amd64.tar.gz

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = "\/chriswalz\/bit\/tree\/v\d{1,3}\.\d{1,3}\.\d{1,3}"
  $url     = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
  $version = $url -split '\/|v' | Select-Object -Last 1
  $url32 = "$releases/download/v$version/bit_$($version)_windows_386.tar.gz"  
  $url64 = "$releases/download/v$version/bit_$($version)_windows_amd64.tar.gz"
  $ReleaseNotesVersion = $version -replace '\.', ''
  return @{ Version = $version; URL = $url32; URL64 = $url64; ChecksumType32 = 'sha512'; ChecksumType64 = 'sha512'; ReleaseNotes = $releaseNotes;}
}

Update-Package -ChecksumFor all