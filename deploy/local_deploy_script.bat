

cd ..\..\NetCore.Customers\ClothingStoreFranchise.NetCore.Customer\
start cmd.exe /c dotnet run --urls=http://localhost:4550/

cd ..\..\NetCore.Catalog\ClothingStoreFranchise.NetCore.Catalog\
start cmd.exe /c dotnet run --urls=http://localhost:4551/

cd ..\..\NetCore.Employees\ClothingStoreFranchise.NetCore.Employees\
start cmd.exe /c dotnet run --urls=http://localhost:4552/

cd ..\..\ClothingStoreFranchise\deploy\