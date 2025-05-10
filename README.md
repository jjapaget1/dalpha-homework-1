# dalpha-homework

Cursor나 VS code를 사용해서 개발 하는 것을 추천 드립니다!

## Docker로 개발 환경 설정 하기 및 github 간단하게 익히기

1. 현재 repository에 있는 파일들의 역할을 파악하기
2. Docker image를 build 하고 container run 하기
3. Cursor (or VS code) 를 활용하여 해당 container에 attach 하기
4. container 내부에서 main.py 실행하여 Hello, World 출력 하기
5. 위의 과정을 파악하여 build_image.sh 및 Dockerfile의 역할 파악하기
6. 파악한 것들을 local 파일에 작성하여 git에 push 하기

## 공부한 것들
1) 현재 repository에 있는 파일들의 역할을 파악하기

0. git 왜 씀?
협업 도구로서 Git은 뭐가 좋은가?
1) 변경 이력 추적
- 누가 어떤 파일을 언제, 왜 바꿨는지 남김없이 기록
- 실수하면 언제든지 되돌리기(rollback) 가능

2) 브랜치 기능
- main, dev, feature/login 등 독립적인 작업 공간을 만들어서 실험 가능
- 테스트 후 문제 없을 때만 병합(merge) 가능
→ 실서비스 코드 안정 유지

3) 충돌 방지 및 해결
- 두 명 이상이 같은 파일을 수정해도 Git이 알아서 병합 시도
- 충돌 발생 시 어느 부분이 충돌났는지 알려줌

4) 원격 저장소와 연동
- GitHub, GitLab, Bitbucket 등과 연결해서
- 다른 사람과 코드 공유하거나 PR(Pull Request)로 리뷰 받음

그래서 아래와 같은 명령어가 있다.

git init	Git 저장소 시작
git status	현재 변경사항 확인
git add	변경사항 staging
git commit	변경사항 저장 (스냅샷 찍기)
git log	커밋 이력 보기
git diff	변경된 부분 비교
git branch	새 브랜치 만들기
git checkout	브랜치 이동
git merge	브랜치 병합
git push	원격 저장소에 업로드
git pull	원격 저장소에서 최신 상태 가져오기

===========================================================

1. .gitignore
git은 소스 코드의 변경 이력을 기록
- 언제 어떤 변경이 있었는지 추적
- 협업시 충돌 방지

하지만 버전 관리가 불필요 or 위험한 파일 존재

자동 생성되므로 관리할 필요 없음	__pycache__/, .pyc, .ipynb_checkpoints/
각자의 컴퓨터마다 다름	                .env, venv/, .vscode/, *.log
용량이 크거나 민감한 정보 포함	.env, db.sqlite3, *.log, *.pkl
보안 위험	API 키, DB 비번이 담긴  .env 파일

이 파일들을 git에 올리면 
- 다른 사람의 환경에서 오류 발생
- 보안문제 발생(API 키 등이 외부에 노출)
- 불필요하게 git 용량 차지

그래서 아래와 같은 것들을 .gitignore을 사용해 무시

자동 생성 파일	어차피 실행할 때 다시 만들어짐
개인 설정 파일	각자 환경이 다름 (IDE 설정 등)
민감 정보	        외부에 노출되면 안 됨
가상환경 폴더	컴퓨터마다 다르고 용량 큼
실행 결과물	        .log, .sqlite3, dist/ 등

*.py[cod]의 의미는
.pyc, .pyo, .pyd로 끝나는 파일들을 무시해라, .py 무시 x

pyenv - 여러 버전에서 돌아갈 때 무시, 같은 버전 강제할 때는 무시x ex) .python-version
pipenv - 보통 포함함. 근데 os마다 패키지 호환성 이슈가 있을 수 있어서 협업시 문제가 생길수도 ex) Pipfile.lock
uv - lock 파일 재현 가능한 환경일 때 중요
poetry - 프로젝트가 어떤 정확한 패키지를 쓰는지를 기록, "재현 가능한 환경을 위해 poetry.lock은 커밋해야 한다"
pdm - 의존성 고정 파일, 팀마다 다를 수 있어서 무시하는게 일반적

각 상황별 .lock 파일 판단기준
1) 어플리케이션 --> .lock 파일 포함
- 웹 서버, API 서버, 머신러닝 학습기
- 같은 환경에서 실행되는게 중요 

2) 재사용 가능한 라이브러리 --> .lock 파일 ignore
- 다른 프로젝트에서 재사용될 전제로 만듬
- 환경 고정시 충돌 가능

3) 협업 상황 --> .lock 파일 포함
- 각자 설치된 패키지 버전이 달라질 위험이 있음
- 모두가 동일한 환경에서 개발하도록 유도

===========================================================

2. Dockerfile

dockerfile --> 내 코드를 "어디서든 똑같이 실행"할 수 있게 해주는 격리된 실행 환경을 만들어주는 도구
- 내 컴퓨터, 팀원 컴퓨터, 서버 어디서든 환경이 같아짐

Dockerfile	도커 이미지를 만들기 위한 설정 파일 (레시피)
Image	설정을 바탕으로 만든 환경 덩어리 (read-only)
Container	이미지를 실행한 실제 프로그램 환경 (read-write 가능)
Build	        Dockerfile을 바탕으로 이미지를 만드는 과정
Run	        이미지를 실행해서 컨테이너를 만드는 과정

3. LICENSE

4. README.md

5. build_image.sh

6. main.py

7. poetry.lock
pyproject.toml에 정의된 의존성(dependencies)을 바탕으로 정확히 어떤 버전의 패키지가 설치되었는지를 기록하는 파일

왜 필요할까?
pyproject.toml에는 fastapi = "^0.109.2"처럼 범위 기반 버전만 명시돼.
- 설치 시마다 0.109.x 중 최신 버전이 설치될 수도 있음

반면 poetry.lock은 fastapi 0.109.2를 정확히 고정시켜줌
- 팀원들끼리, 혹은 배포 서버에서 항상 같은 환경을 재현할 수 있음

 그럼 poetry.lock만 있으면 안 되나?
poetry.lock만 있어도 정확한 패키지 버전 정보는 있지만,

어떤 프로젝트인지 설명할 정보 (name, version, dependencies 조건 등)는 없음

poetry install조차도 pyproject.toml이 없으면 실행 안 됨

- 다시 말해, poetry.lock은 pyproject.toml 없이는 혼자서 의미가 없음

8. pyproject.toml

왜 Python 코드가 아닌 TOML을 씀?
--> 간단하고 직관적이기 때문

JSON보다 보기 좋고, YAML보다 덜 복잡함

예: key-value, 배열, 테이블 등 모두 쉽게 표현 가능

- 언어 중립적이라 안전함

TOML은 코드가 아니라 데이터만 표현하니까

악성코드처럼 실행될 일이 없음 (JSON이나 Python 코드보다 안전)

- Python 생태계에서 공식 표준으로 채택됨

pyproject.toml은 PEP 518에 정의된 공식 표준임

Python 빌드 툴 간의 통일된 인터페이스를 만들기 위해 만들어짐

[tool.poetry]                     프로젝트 기본 정보
[tool.poetry.dependencies]  패키지 의존성 (뭐 설치할지)
[build-system]                  Poetry 자체 빌드 설정

^3.10은 3.10 이상 ~ 4.0 미만을 의미 (3.11, 3.12 OK)

requires = ["poetry-core"]
빌드에 필요한 패키지 (poetry-core)를 명시

이것 덕분에 pip install .로도 패키지를 만들 수 있dma

build-backend = "poetry.core.masonry.api"
poetry의 실제 빌드 로직을 수행하는 내부 API

이건 보통 고치지 않고 그대로 둔다. Poetry가 자동 생성한 부분


이미지 생성(dalpha-env 빌드)
docker build -t dalpha-env .

컨테이너 실행
docker run -it --rm dalpha-env

git에 푸쉬할 때
git add .  (.은 현재 디렉토리 내 전체 변경사항 올리기, git add main.py로 하면 main.py만 올리는거)
git commit -m "feat: 수정한 내용 간단히 적기"
git push origin main
