# 📱 프로젝트명 - 아이모리 어린이집 업무 자동화 서비스 앱

**Flutter 기반의 Aimory App 프로젝트입니다.**  
-

## 📌 프로젝트 소개
아이모리(Ai-mory)는 **인공지능을 활용한 어린이집 원아 기록 애플리케이션**으로, 
AI와 Memory를 결합한 이름을 가집니다. 
이 서비스는 공지사항, 알림장, 사진첩 기능을 제공하여 
**교사의 업무 효율성을 높이고 학부모와 교사 간의 소통을 강화**하는 것을 목표로 합니다.
-

## 🎯 주요 기능
✔ **REST API 연동**   
✔ **JWT 로그인**   
✔ **갤러리를 활용한 사진첩 기능**  
✔ **OpenAI ChatGPT API 연동**  
-

## 📂 폴더 구조
```bash
aimory_app/
 ├── android/               
 ├── ios/                   
 ├── assets/                
 ├── lib/                   # 메인 프로젝트 폴더
 │   ├── core/              # 앱의 핵심 기능 및 공통 요소
 │   │   ├── const/         # 상수 데이터
 │   │   ├── screens/       # 공통 화면 컴포넌트
 │   │   ├── util/          # 유틸리티 함수
 │   │   ├── widgets/       # 재사용 위젯
 │   ├── features/          # 주요 기능별 폴더
 │   │   ├── auth/          # 인증 관련 기능
 │   │   │   ├── models/    # 모델
 │   │   │   ├── providers/ # 상태 관리
 │   │   │   ├── screens/   
 │   │   │   ├── services/  # 서비스
 │   │   ├── home/          # 홈 화면
 │   │   ├── notes/         # 알림장 기능
 │   │   ├── notices/       # 공지사항 기능
 │   │   ├── photos/        # 사진 업로드 및 관리
 │   │   ├── search/        # 검색 기능
 │   ├── main.dart          
 ├── .dart_tool/            
 ├── .idea/                 
 ├── build/                 
