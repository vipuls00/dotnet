# Define the base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 8080

# Define the build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-nanoserver-1809 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["SampleMVC.csproj", "SampleMVC/"]
USER ContainerUser
RUN dotnet restore "SampleMVC/SampleMVC.csproj"
COPY . .
WORKDIR "/src/SampleMVC"
RUN dotnet build "SampleMVC.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Define the publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SampleMVC.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Define the final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleMVC.dll"]

