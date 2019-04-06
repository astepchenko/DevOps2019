MusicStore (test application)
=============================

AppVeyor: [![AppVeyor][appveyor-badge]][appveyor-build]

Travis:   [![Travis][travis-badge]][travis-build]

[appveyor-badge]: https://ci.appveyor.com/api/projects/status/ja8a7j6jscj7k3xa/branch/dev?svg=true
[appveyor-build]: https://ci.appveyor.com/project/aspnetci/MusicStore/branch/dev
[travis-badge]: https://travis-ci.org/aspnet/MusicStore.svg?branch=dev
[travis-build]: https://travis-ci.org/aspnet/MusicStore

This project is part of ASP.NET Core. You can find samples, documentation and getting started instructions for ASP.NET Core at the [Home](https://github.com/aspnet/home) repo.

## About this repo

This repository is a test application used for ASP.NET Core internal test processes.
It is not intended to be a representative sample of how to use ASP.NET Core.

Samples and docs for ASP.NET Core can be found here: <https://docs.asp.net>.


First of all change server name to **SERVER**

## Install choco
```
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

## Install packages
```
choco install dotnetcore-sdk --version 2.0 -y
choco install dotnetfx -y
choco install sql-server-express -y
choco install sql-server-management-studio -y
choco install octopusdeploy -y
choco install octopusdeploy.tentacle -y
choco install octopustools -y
choco install jenkins -y
choco install git -y
choco install nuget.commandline -y
```

## Build app
```
cd C:\DevOps2019
dotnet publish --framework netcoreapp2.0
```

## Run app
```
cd C:\DevOps2019\samples\MusicStore\bin\Debug\netcoreapp2.0\publish
dotnet MusicStore.dll
```