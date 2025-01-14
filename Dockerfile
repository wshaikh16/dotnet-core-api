FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["dotnet-core-api/TodoApi.csproj", "dotnet-core-api/"]
RUN dotnet restore "dotnet-core-api/TodoApi.csproj"
COPY . .
WORKDIR "/src/dotnet-core-api"
RUN dotnet build "TodoApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TodoApi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TodoApi.dll"]