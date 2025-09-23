# --- 第一階段：建置階段 (Builder Stage) ---
# 使用一個包含 Maven 和 JDK 17 的映像作為建置環境
FROM maven:3.9.8-eclipse-temurin-17 AS builder

# 設定工作目錄
WORKDIR /build

# 複製 pom.xml 並下載依賴項
# 這樣可以利用 Docker 的快取機制，如果依賴項不變，就不用重新下載
COPY pom.xml .
RUN mvn dependency:go-offline

# 複製專案的原始碼
COPY src ./src

# 執行 Maven 打包指令，跳過測試
# 這裡會產生 target/app.jar
RUN mvn clean package -DskipTests


# --- 第二階段：運行階段 (Runner Stage) ---
# 使用一個輕量級的 JRE 映像作為最終的運行環境
FROM eclipse-temurin:17-jre-jammy

# 設定工作目錄
WORKDIR /app

# 從第一階段(builder)中，只複製建置好的 JAR 檔到目前階段
COPY --from=builder /build/target/app.jar .

# 宣告應用程式將運行的端口 (Spring Boot 預設為 8080)
EXPOSE 8080

# 容器啟動時運行的指令
ENTRYPOINT ["java", "-jar", "app.jar"]