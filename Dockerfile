# Use the official .NET SDK image as the build stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory
WORKDIR /src

# Copy the solution file and restore the dependencies
COPY ["Alpha.sln", "./"]
COPY ["src/Alpha.API/Alpha.API.csproj", "src/Alpha.API/"]
COPY ["src/Alpha.Domain/Alpha.Domain.csproj", "src/Alpha.Domain/"]
COPY ["src/Alpha.Infrastructure/Alpha.Infrastructure.csproj", "src/Alpha.Infrastructure/"]
COPY ["src/Alpha.Application/Alpha.Application.csproj", "src/Alpha.Application/"]
COPY ["tests/Alpha.Tests/Alpha.Tests.csproj", "tests/Alpha.Tests/"]
RUN dotnet restore "Alpha.sln"

# Copy the rest of the source code
COPY . .

# Build the entire solution
RUN dotnet build "Alpha.sln" -c Release -o /app/build

# Publish the Web API project
RUN dotnet publish "src/Alpha.API/Alpha.API.csproj" -c Release -o /app/publish

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
ENTRYPOINT ["dotnet", "Alpha.API.dll"]
