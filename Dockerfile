# "Poetry를 이용한 Python 개발 환경을 Docker 컨테이너 안에 만들고,
# 코드까지 넣은 뒤 bash 셸로 진입하게 한다."

# FROM - 어떤 이미지로 시작할지
# As - base로 이름 붙임
# bullseye - 리눅스 컴퓨터(debian)
FROM python:3.10-bullseye AS base 

# noninteractive - 패키지 설치 도중 **사용자에게 묻는 메시지(yes/no 등)**를 안 띄우게 설정.
# 즉, 무조건 "yes"로 자동 설치되게 만듦 (CI/CD에서 주로 사용)
# 기본시간대(timezone)을 서울로 설정, 시간 관련 작업에 영향을
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# update and install packages

# apt - debian 계열의 패키지 관리자, get update - 패키지 목록 최신화화
RUN apt-get update
# 필수 도구들 설치
RUN apt-get install -y --no-install-recommends \
    build-essential \
    awscli \
    zip \
    unzip \
    curl \
    git \
    software-properties-common \
    vim

# 패키지 목록 캐시 삭제 - 도커 이미지 용량 최적화화
RUN rm -rf /var/lib/apt/lists/*

# 외부 패키지(예를 들어 requests.get()을 쓰면 requests는 의존성)
# poetry.lock 는 requests의 버전과 같은 의존성을 고정한다.
# poetry는 python용 의존성 관리 도구
# python 프로젝트를 깔끔하게 만들고, 필요한 패키지를 자동으로 설치
# curl로 poetry 설치 스크립트 다운, 실행, 버전 고정
# echo는 기본 쉘에 poetry 설치 경로를 등록하는 과정
# 쉘이 열릴 때마다 poetry 명령어가 자동 등록됨
RUN curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.8.3 python3 - && \
    echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc && \
    echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.profile

ENV PATH="/root/.local/bin:$PATH"

#명령어들이 실행될 기본 작업 디렉토리를 /workspace로 설정
WORKDIR /workspace

# pyproject.toml로부터 poetry.lock을 확인하고 갱신 (하지만 --no-update)
# → 의존성 재검토만 하고, 바꾸진 않음
# -vvv: verbose 모드, 자세한 로그 출력
COPY pyproject.toml poetry.lock /workspace/

RUN poetry lock --no-update --no-interaction --no-ansi -vvv

RUN poetry install --no-interaction --no-ansi -vvv

#이제 프로젝트의 전체 파일 복사
#(main.py, .gitignore, README.md, 등 전부 포함)
COPY . /workspace

#쉘을 실행하여 리눅스 터미널로 진입, 하고싶은거 하자자
CMD ["/bin/bash"]