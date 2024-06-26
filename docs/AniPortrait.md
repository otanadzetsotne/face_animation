# AniPortrait

## Спецификации

* \>16Gb GPU RAM

## Описание файлов в /additional_files/AniPortrait:
* `requirements.txt` - Исправленные зависимости проекта
* `xformers_fix.sh` - Хак для установки python библиотеки `xformers`
* `download_weights.sh` - Загружает необходимые веса моделей.
 Ожидает параметр - путь к папке `*/AniPortrait/pretrained_models`

## Запуск демо:
```
python -m scripts.audio2vid --config ./configs/prompts/animation_audio.yaml -W 512 -H 512
```
Референсы необходимо прописать в параметр `test_cases`, файла `/AniPortrait/configs/prompts/animation_audio.yaml`

## Apple Silicon:

Необходимо использовать `PYTORCH_ENABLE_MPS_FALLBACK=1` для оператора `aten::upsample_linear1d.out` при использовании `device="mps"`

## Проблемы

В ходе попыток запустить обработку изображения столкнулся с рядом проблем, которые так и не удалось исправить полностью из-за чего не получилось запустить обработку на локальной машине.

Лог работы:
1. Доработал проект для работы с `device="mps"` (графическое ядро процессора m1)
2. Столкнулся с использованием смешанных типов данных тензоров (`f16` и `f32`).
 Нашел и заменил все используемые типы данных на `f32` что бы исправить проблему.
3. Столкнулся с отсутствием одного из операторов на девайсах `"mps"`. [Исправление](#apple-silicon)
4. Оказалось, что локальная машина с 16Gb оперативной памяти недостаточна для запуска генерации видео на графических ядрах m1.
 Снял ограничение на использование памяти в попытке избежать краша приложения, но это не дало результат.
 Вернулся к пункту **1** и заменил девайсы всех тензоров на `"cpu"`.
5. Столкнулся с проблемой утечки данных:
   ```
   UserWarning: resource_tracker: There appear to be 1 leaked semaphore objects to clean up at shutdown
   warnings.warn('resource_tracker: There appear to be %d '
   ```
   Гипотизы и попытки решения ([Issues](https://github.com/apple/ml-stable-diffusion/issues/8)):
   1. Библиотека `tqdm` может создавать утечку данных из-за неточности подсчета статистики. 
    Апгрейд и даунгдейр на известные работающие версии `tqdm` не дал результатов.
   2. Некорректная версия `torch`.
    Обновил `torch` и `torchvision`, заменив их на версии, скомпилированные для работы на `"cpu"`.
   3. Одно из возможных решений - даунгрейд версии питона на известно работающую `3.10.13`.
   
   Не одна из попыток решения не дала результат. На данный момент основываясь на отсутствии логов,
 невозможности отловить ошибку средствами дебаггера, и чрезмерном использовании оперативной и свап памяти,
 считаю, что проблема все еще в отсутвии достаточной оперативной памяти для запуска скрипта.
 Нужно протестировать проект еще раз на машине с большими ресурсами.
6. Гипотеза в пункте 5 оказалась верной, скрипт удалось запустить уменьшив размер видео с 512х512px до 200х200px.
 Тем не менее скорость обработки даже такого маленького разрешения на графических ядрах M1 слишком медленная.
 Для обработки целевого аудио+фото необходимо более 3-х часов. При этом, в проблемах проекта на GitHub упоминалось,
 что существует проблема обрезания итогового видео по времени по сравнению с целевым аудио.
 Решения этой проблемы в issues не дано, поэтому ждать 3 часа считаю не целесообразным.
 Нужно протестировать на более мощной машине
 (Так же в issues есть данные о том, что GPU с 16Gb Ram может выдавать OOM. Нужно это учесть).
 *Так же были изменены все тензоры для работы на сpu - на m1 это немного ускорило обработку, но все еще занимает до 3-х часов*
