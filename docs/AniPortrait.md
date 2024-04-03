# AniPortrait

Описание файлов в /additional_files/AniPortrait:
* `requirements.txt` - Исправленные зависимости проекта
* `xformers_fix.sh` - Хак для установки python библиотеки `xformers`
* `download_weights.sh` - Загружает необходимые веса моделей.
 Ожидает параметр - путь к папке `*/AniPortrait/pretrained_models`

Запуск демо:
```
python -m scripts.audio2vid --config ./configs/prompts/animation_audio.yaml -W 512 -H 512
```
Референсы необходимо прописать в параметр `test_cases`, файла `/AniPortrait/configs/prompts/animation_audio.yaml`
