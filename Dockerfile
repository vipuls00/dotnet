
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

WORKDIR /app
EXPOSE 8080
ENV CONNECTION_STRING="your_connection_string_here"
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["./SampleMVC.csproj", "SampleMVC/"]
RUN dotnet restore "./SampleMVC/SampleMVC.csproj"
WORKDIR "/src/SampleMVC"
COPY . .

 RUN dotnet build "./SampleMVC.csproj" -c ${BUILD_CONFIGURATION} -o /app/build


FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./SampleMVC.csproj" -c ${BUILD_CONFIGURATION} -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleMVC.dll"]