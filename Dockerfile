# 使用包含 Java 17 的基礎映像，與您的 pom.xml 匹配
FROM eclipse-temurin:17-jdk-jammy

# 設定容器內的工作目錄
WORKDIR /app

# 將編譯好的 JAR 檔案複製到容器中
# 這裡的 app.jar 對應您在 pom.xml 設定的 finalName
COPY target/app.jar app.jar

# 宣告應用程式將運行的端口 (Spring Boot 預設為 8080)
EXPOSE 8080

# 容器啟動時運行的指令
ENTRYPOINT ["java", "-jar", "app.jar"]