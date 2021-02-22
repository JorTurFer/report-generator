FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build-env
WORKDIR /app

RUN apk update && \
    apk add git && \
    git clone https://github.com/danielpalme/DotnetGlobalTool.git && \
    cd ReportGenerator/src/ReportGenerator.DotnetCliTool && \
    dotnet restore && \
    dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:5.0-alpine
WORKDIR /app
COPY --from=build-env /app/ReportGenerator/src/ReportGenerator.DotnetCliTool/out .
ENTRYPOINT ["dotnet", "dotnet-reportgenerator.dll"]
