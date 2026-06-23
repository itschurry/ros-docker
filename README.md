# ros-docker

ROS 2 프로젝트에서 공통 베이스 이미지로 쓰기 위한 Docker 이미지야.
기본 베이스는 `ros:jazzy-ros-base`고, 개발 도구와 자주 쓰는 ROS 패키지를 같이 설치해.

## 설치

Docker Compose 플러그인이 필요해.

```bash
docker compose version
```

## 실행

이미지 빌드:

```bash
docker compose build ros-base
```

컨테이너 쉘 실행:

```bash
docker compose run --rm ros-base
```

이미지 푸시:

```bash
docker compose push ros-base
```

다른 ROS 프로젝트 `Dockerfile`에서 베이스 이미지로 사용:

```dockerfile
FROM ghcr.io/itschurry/ros:jazzy
```

## 설정

`.env`에서 빌드 옵션을 바꿔.

```env
ROS_DISTRO=jazzy
ROS_IMAGE=ghcr.io/itschurry/ros
ROS_IMAGE_TAG=jazzy
DOCKER_PLATFORM=linux/amd64
```

- `ROS_DISTRO`: 설치할 ROS 2 배포판 이름
- `ROS_IMAGE`: 빌드 결과 이미지 이름
- `ROS_IMAGE_TAG`: 빌드 결과 이미지 태그
- `DOCKER_PLATFORM`: 빌드 대상 플랫폼

## 디렉터리 구조

```text
.
├── .env
├── Dockerfile
├── docker-compose.yml
├── build.sh
└── README.md
```
