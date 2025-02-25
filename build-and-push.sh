#!/bin/bash

# Путь к папке, где нужно выполнить git describe
REPO_PATH="."

# Проверяем, существует ли папка
if [ ! -d "$REPO_PATH" ]; then
  echo "Ошибка: Папка $REPO_PATH не найдена."
  exit 1
fi

# Получаем текущий тег Git из указанной папки
VERSION=$(git -C "$REPO_PATH" describe --tags --abbrev=0 | sed 's/^v//')

if [ -z "$VERSION" ]; then
  echo "Ошибка: Тег не найден в репозитории $REPO_PATH. Убедитесь, что он существует."
  exit 1
fi

# Устанавливаем имя образа
IMAGE_NAME="sc-docker-registry.io:30500/datalens-us"
echo "Строим образ: $IMAGE_NAME:$VERSION"
# Строим Docker-образ с указанным тегом и latest
docker build  -t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest -f patch-us/Dockerfile .


# Проверяем успешность последнего билда
if [ $? -ne 0 ]; then
  echo "Ошибка: Последний билд завершился с ошибкой. Проверьте логи."
  exit 1
fi

# Проверяем наличие собранного образа
if ! docker images | grep -q "${IMAGE_NAME}.*${VERSION}"; then
  echo "Ошибка: Образ $IMAGE_NAME:$VERSION не найден. Пуш невозможен."
  exit 1
fi
# Пушим образы в Docker-реестр
docker push ${IMAGE_NAME}:${VERSION}
docker push ${IMAGE_NAME}:latest
