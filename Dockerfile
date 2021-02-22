FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build-env
WORKDIR /app

RUN apk update && \
    apk add git && \
    git clone https://github.com/danielpalme/ReportGenerator.git && \
    cd ReportGenerator/src/ReportGenerator.DotnetGlobalTool && \
    dotnet restore && \
    dotnet publish -c Release -f net5.0 -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:5.0-alpine
WORKDIR /app
COPY --from=build-env /app/ReportGenerator/src/ReportGenerator.DotnetGlobalTool/out .
ENTRYPOINT ["dotnet", "ReportGenerator.dll"]
