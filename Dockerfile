# Define the base image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["SampleMVC.csproj", "SampleMVC/"]
RUN dotnet restore "./SampleMVC/SampleMVC.csproj"

WORKDIR "/src/SampleMVC"
COPY . .
RUN dotnet build "./SampleMVC.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Define the publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SampleMVC.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Define the final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleMVC.dll"]

