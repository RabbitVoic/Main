﻿&НаСервереБезКонтекста
Функция ПолучитьКонтактноеЛицоПоПолучателю(Получатель)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Контрагенты.КонтактноеЛицо
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Получатель";
	Запрос.Параметры.Вставить("Получатель", Получатель);
	Выборка = Запрос.Выполнить().Выбрать();
	КонтактноеЛицо = "";
	Если Выборка.Следующий() Тогда
		КонтактноеЛицо = Выборка.КонтактноеЛицо;
	КонецЕсли;
	Возврат КонтактноеЛицо;
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьПолучателей(Получатель, Получатели)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Контрагенты.ЭлектроннаяПочта
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка ";
	Если ТипЗнч(Получатели) = Тип("Массив") Тогда
		Запрос.Текст = Запрос.Текст + "В (&Получатели)";
	Иначе
		Запрос.Текст = Запрос.Текст + "= &Получатели";
	КонецЕсли;
	Запрос.Параметры.Вставить("Получатели", Получатели);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Получатель <> "" Тогда
			Получатель = Получатель + "; ";
		КонецЕсли;
		Получатель = Получатель + Выборка.ЭлектроннаяПочта;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() Тогда
		Заголовок = "Исходящее письмо (Создание)";
		Объект.Дата = ТекущаяДата();
		ПоШаблону = Параметры.Свойство("ПоШаблону");
		ВходящееПисьмо = Параметры.ВходящееПисьмо;
		Если ПоШаблону = Истина Тогда
			Элементы.ЗаполнитьПоШаблону.Видимость = Истина;
			РаботаСПочтой.ЗаполнитьПисьмоПоШаблону(Объект, Содержимое);
		ИначеЕсли Не ВходящееПисьмо.Пустая() Тогда
			РаботаСПочтой.ЗаполнитьОтветНаПисьмо(ВходящееПисьмо, Объект, Содержимое);
		КонецЕсли;
		Адресаты = Параметры.Адресаты;
		Если Адресаты <> Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	Контрагенты.ЭлектроннаяПочта
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.Ссылка В(&Адресаты)
			|	И Контрагенты.ЭлектроннаяПочта <> """"";
			Запрос.УстановитьПараметр("Адресаты", Адресаты);
			Получатель = "";
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Получатель <> "" Тогда
					Получатель = Получатель + "; ";
				КонецЕсли;
				Получатель = Получатель + Выборка.ЭлектроннаяПочта;
			КонецЦикла;
			Объект.Получатель = Получатель;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Содержимое = ТекущийОбъект.Содержимое.Получить();
	Заголовок = ТекущийОбъект.Наименование + " (Исходящее письмо)";
	Если  РаботаСПочтой.ПисьмоОтправлено(ТекущийОбъект.Ссылка) Тогда
		Заголовок = Заголовок + " - Отправлено";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.Содержимое = Новый ХранилищеЗначения(Содержимое, Новый СжатиеДанных());
	ТекущийОбъект.Текст = Содержимое.ПолучитьТекст();
КонецПроцедуры

&НаСервере
Функция ОтправитьПисьмо(Ошибка)
	Если Не Записать() Тогда
		Ошибка = "ОшибкаЗаписи";
		Возврат Ложь;
	КонецЕсли;
	Если Не РаботаСПочтой.ОтправитьПисьмо(Объект.Ссылка) Тогда
		Ошибка = "ОшибкаОтправки";
		Возврат Ложь;
	КонецЕсли;
	Заголовок = Заголовок + " - Отправлено";
	Возврат Истина;
КонецФункции

&НаКлиенте
Асинх Функция ОтправитьПисьмоКлиент()
	Ошибка = "";
	Если Не ОтправитьПисьмо(Ошибка) Тогда
		Если Ошибка = "ОшибкаОтправки" Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(1, НСтр("ru = 'Настроить почту'"));
			Кнопки.Добавить(2, НСтр("ru = 'Закрыть'"));
			РезультатВопросаОНастройке = Ждать ВопросАсинх(НСтр("ru = 'Не указаны настройки интернет почты!'"),
				Кнопки,
				,
				1);
			Если РезультатВопросаОНастройке = 1 Тогда
				ОткрытьФорму("ОбщаяФорма.НастройкаПочты");
			КонецЕсли;
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Объект.Ссылка);
	ПоказатьОповещениеПользователя("Письмо отправлено", НавигационнаяСсылка, Объект.Наименование);
	ОповеститьОбИзменении(Объект.Ссылка);
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ОтправитьПисьмоКлиентВопросЗавершение(Результат, Параметры) Экспорт
	Если Результат = 1 Тогда
		ОткрытьФорму("ОбщаяФорма.НастройкаПочты");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	ОтправитьПисьмоКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьИЗакрыть(Команда)
	АсинхОтправитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Асинх Процедура АсинхОтправитьИЗакрыть()
	Если Не Ждать ОтправитьПисьмоКлиент() Тогда
		Возврат;
	КонецЕсли;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтрокуВТекущуюПозицию(Поле, Документ, Строка)
	Перем Начало, Конец;
	
	Поле.ПолучитьГраницыВыделения(Начало, Конец);
	Позиция = Документ.ПолучитьПозициюПоЗакладке(Начало);
	Документ.Удалить(Начало, Конец);
	Начало = Документ.ПолучитьЗакладкуПоПозиции(Позиция);
	Документ.Вставить(Начало, Строка);
	Позиция = Позиция + СтрДлина(Строка);
	Закладка = Документ.ПолучитьЗакладкуПоПозиции(Позиция);
	Поле.УстановитьГраницыВыделения(Закладка, Закладка);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицо(Команда)
	Если Объект.Контрагент.Пустая() Тогда
		Сообщить("Выберите контрагента");
	Иначе
		КонтактноеЛицо = ПолучитьКонтактноеЛицоПоПолучателю(Объект.Контрагент);
		ВставитьСтрокуВТекущуюПозицию(Элементы.Содержимое, Содержимое, КонтактноеЛицо + " ");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Заголовок = ТекущийОбъект.Наименование + " (Исходящее письмо)";
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ДобавитьПолучателей(Объект.Получатель, Объект.Контрагент);
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВажное(Команда)
	Перем Начало, Конец;
	
	ВсеВажное = Истина;
	Элементы.Содержимое.ПолучитьГраницыВыделения(Начало, Конец);
	Если Начало = Конец Тогда
		Возврат;
	КонецЕсли;
	
	НаборТекстовыхЭлементов = Новый Массив();
	Для Каждого ТекстовыйЭлемент Из Содержимое.СформироватьЭлементы(Начало, Конец) Цикл
		Если Тип(ТекстовыйЭлемент) = Тип("ТекстФорматированногоДокумента") Тогда
			НаборТекстовыхЭлементов.Добавить(ТекстовыйЭлемент);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекстовыйЭлемент Из НаборТекстовыхЭлементов Цикл
		Если ТекстовыйЭлемент.Шрифт.Жирный <> Истина И
			ТекстовыйЭлемент.ЦветТекста <> Новый Цвет(255, 0, 0) Тогда
			ВсеВажное = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекстовыйЭлемент Из НаборТекстовыхЭлементов Цикл
		ТекстовыйЭлемент.Шрифт = Новый Шрифт(ТекстовыйЭлемент.Шрифт, , , Не ВсеВажное);
		ТекстовыйЭлемент.ЦветТекста = Новый Цвет(?(ВсеВажное, 0, 255), 0, 0);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	Если Объект.Контрагент.Пустая() Тогда
		Сообщить("Выберите контрагента");
	Иначе
		НайтиИЗаменить("[Контрагент]", Объект.Контрагент);
		НайтиИЗаменить("[КонтактноеЛицо]", ПолучитьКонтактноеЛицоПоПолучателю(Объект.Контрагент));
	КонецЕсли;
	НайтиИЗаменить("[ДатаПисьма]", Объект.Дата);
КонецПроцедуры

&НаКлиенте
Процедура НайтиИЗаменить(СтрокаДляПоиска, СтрокаДляЗамены)
	Перем ВставленныйТекст, ШрифтОформления, ЦветТекстаОформления, ЦветФонаОформления, НавигационнаяСсылкаОформления;
	
	РезультатПоиска = Содержимое.НайтиТекст(СтрокаДляПоиска);
	Пока ((РезультатПоиска <> Неопределено) И (РезультатПоиска.ЗакладкаНачала <> Неопределено) И (РезультатПоиска.ЗакладкаКонца <> Неопределено)) Цикл
		ПозицияНачалаСледующегоЦиклаПоиска = Содержимое.ПолучитьПозициюПоЗакладке(РезультатПоиска.ЗакладкаНачала) + СтрДлина(СтрокаДляЗамены);
		МассивЭлементовДляОформления = Содержимое.ПолучитьЭлементы(РезультатПоиска.ЗакладкаНачала, РезультатПоиска.ЗакладкаКонца);
		Для Каждого ЭлементДляОформления Из МассивЭлементовДляОформления Цикл
			Если Тип(ЭлементДляОформления) = Тип("ТекстФорматированногоДокумента") Тогда
				ШрифтОформления = ЭлементДляОформления.Шрифт;
				ЦветТекстаОформления = ЭлементДляОформления.ЦветТекста;
				ЦветФонаОформления = ЭлементДляОформления.ЦветФона;
				НавигационнаяСсылкаОформления = ЭлементДляОформления.НавигационнаяССылка;
				Прервать;
			КонецЕсли;
		КонецЦикла;	
		Содержимое.Удалить(РезультатПоиска.ЗакладкаНачала, РезультатПоиска.ЗакладкаКонца);
		ВставленныйТекст = Содержимое.Вставить(РезультатПоиска.ЗакладкаНачала, СтрокаДляЗамены);
		Если ВставленныйТекст <> Неопределено И ШрифтОформления <> Неопределено Тогда
			ВставленныйТекст.Шрифт = ШрифтОформления;
		КонецЕсли;
		Если ВставленныйТекст <> Неопределено И ЦветТекстаОформления <> Неопределено Тогда
			ВставленныйТекст.ЦветТекста = ЦветТекстаОформления;
		КонецЕсли;
		Если ВставленныйТекст <> Неопределено И ЦветФонаОформления <> Неопределено Тогда
			ВставленныйТекст.ЦветФона = ЦветФонаОформления;
		КонецЕсли;
		Если ВставленныйТекст <> Неопределено И НавигационнаяСсылкаОформления <> Неопределено Тогда
			ВставленныйТекст.НавигационнаяССылка = НавигационнаяСсылкаОформления;
		КонецЕсли;
		
		РезультатПоиска = Содержимое.НайтиТекст(СтрокаДляПоиска, Содержимое.ПолучитьЗакладкуПоПозиции(ПозицияНачалаСледующегоЦиклаПоиска));
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Отказ = Истина;
		Если ЗавершениеРаботы Тогда
			ДействияПриМодифицирпрванностиПисьмаПриЗавершенииРаботы();
		Иначе
			СтандартнаяОбработка = Ложь;
			ДействияПриМодифицирпрванностиПисьмаПриПродолженииРаботы();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Асинх Процедура ДействияПриМодифицирпрванностиПисьмаПриЗавершенииРаботы()
	ТекстПредупреждения = НСтр("ru='Письмо было изменено. Все изменения будут потеряны.'", "ru");
	Ждать ПредупреждениеАсинх(ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ДействияПриМодифицирпрванностиПисьмаПриПродолженииРаботы()
	Текст = НСтр("ru='Письмо было изменено. Сохранить изменения?'", "ru");
	Режим = РежимДиалогаВопрос.ДаНетОтмена;
	РезультатВопросаОСохраненииИзменений = Ждать ВопросАсинх(Текст, Режим, 0);
	Если РезультатВопросаОСохраненииИзменений = КодВозвратаДиалога.Да Тогда
		Записать();
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли РезультатВопросаОСохраненииИзменений = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

