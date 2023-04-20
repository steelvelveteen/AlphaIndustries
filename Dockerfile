# Use the official .NET SDK image as the build stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory
WORKDIR /src

# Copy the solution file and restore the dependencies
COPY ["AlphaIndustries.sln", "./"]
COPY ["src/AlphaIndustries.API/AlphaIndustries.API.csproj", "src/AlphaIndustries.API/"]
COPY ["src/AlphaIndustries.Domain/AlphaIndustries.Domain.csproj", "src/AlphaIndustries.Domain/"]
COPY ["src/AlphaIndustries.Infrastructure/AlphaIndustries.Infrastructure.csproj", "src/AlphaIndustries.Infrastructure/"]
COPY ["src/AlphaIndustries.Application/AlphaIndustries.Application.csproj", "src/AlphaIndustries.Application/"]
COPY ["tests/AlphaIndustries.API.Tests/AlphaIndustries.API.Tests.csproj", "tests/AlphaIndustries.API.Tests/"]
COPY ["tests/AlphaIndustries.Domain.Tests/AlphaIndustries.Domain.Tests.csproj", "tests/AlphaIndustries.Domain.Tests/"]
COPY ["tests/AlphaIndustries.Application.Tests/AlphaIndustries.Application.Tests.csproj", "tests/AlphaIndustries.Application.Tests/"]
COPY ["tests/AlphaIndustries.Infrastucture.Tests/AlphaIndustries.Infrastucture.Tests.csproj", "tests/AlphaIndustries.Infrastucture.Tests/"]
COPY ["tests/AlphaIndustries.Integration.Tests/AlphaIndustries.Integration.Tests.csproj", "tests/AlphaIndustries.Integration.Tests/"]

RUN dotnet restore "AlphaIndustries.sln"

# Copy the rest of the source code
COPY . .

# Build the entire solution
RUN dotnet build "AlphaIndustries.sln" -c Release -o /app/build

# Publish the Web API project
RUN dotnet publish "src/AlphaIndustries.API/AlphaIndustries.API.csproj" -c Release -o /app/publish

# Use the official .NET runtime image as the final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish .

# Expose the API port
EXPOSE 80
EXPOSE 443

# Set the entrypoint for the application
ENTRYPOINT ["dotnet", "AlphaIndustries.API.dll"]
