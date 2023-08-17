﻿
&НаКлиенте
Процедура ВыполнитьОбменДанными(Команда)
	ВыполнитьОбменДаннымиСервер();
КонецПроцедуры

Процедура ВыполнитьОбменДаннымиСервер()
	 УстановитьПривилегированныйРежим(Истина);
	Старт = ТекущаяДата();
	
	Настройки = ПолучитьНастройкиRabbitMQ_();
	
	Сообщения = Новый Массив; 
	
	Фабрика_XDTO = ПолучитьФабрикуXDTO();
	
	Сообщение = Фабрика_XDTO.Создать(Фабрика_XDTO.Тип("http://rest_rmq", "messages_request"));
	
	Сообщение.count = 100; //количество получаемых сообщений
	Сообщение.ackmode = Настройки.ackmode; // варианты "ack_requeue_true", "reject_requeue_true", "ack_requeue_false", "reject_requeue_false"
	Сообщение.encoding = "auto"; // вариант "base64"
	
	ТекстJSON = ОбъектXDTO_ПолучитьJSON(Сообщение, Фабрика_XDTO);
	
	// %2f это vhost по умолчанию "/"
	АдресРесурса = СтрШаблон("/api/queues/%1/%2/get", "%2f", Настройки.QueueName);
	
	Ответ = ОтправитьHTTPЗапрос(Настройки, АдресРесурса, "POST", ТекстJSON);
	
	Если Ответ.КодСостояния <> 200 Тогда
		Сообщить("Ошибка: " + Ответ.ПолучитьТелоКакСтроку());
		Возврат;
	КонецЕсли;
	
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
	
	ОбъектСообщения = Фабрика_XDTO.ПрочитатьJSON(ЧтениеJSON, Фабрика_XDTO.Тип("http://rest_rmq", "collection_messages_in"));
	
	Для каждого Сообщение Из ОбъектСообщения.message Цикл
		ПрочитанноеСообщение = ПрочитатьЗначениеJSON(Сообщение.payload);
		ДанныеКонтрагента = Новый Структура("УИДКонтрагента,Наименование,Телефон,Почта,ТипЗаписи",
		ПрочитанноеСообщение.УИДКонтрагент,ПрочитанноеСообщение.Контрагент,ПрочитанноеСообщение.КонтрагентТелефон,ПрочитанноеСообщение.КонтрагентЭлектроннаяПочта,"Контрагент");
		Контрагент = ПроверкаНаНаличие(ДанныеКонтрагента);
		ДанныеДоговора = Новый Структура("УИД,ДатаЗаключения,НомерДоговора,Контрагент,ТипЗаписи",
		ПрочитанноеСообщение.УИДДоговор,ПрочитанноеСообщение.ДатаЗаключенияДоговора,ПрочитанноеСообщение.НомерДоговора,Контрагент,"Договор");
		Договор = ПроверкаНаНаличие(ДанныеДоговора);
		
		ТабЧастьТовары = Новый ТаблицаЗначений();
		ТабЧастьТовары.Колонки.Добавить("Товар");
		ТабЧастьТовары.Колонки.Добавить("Количество");
		Для Каждого СтрукТовар ИЗ ПрочитанноеСообщение.Товары Цикл
			
			ДанныеТовара = Новый Структура("УИДТовара,Товар,ТипЗаписи",
			СтрукТовар.Значение.УИДТовара,СтрукТовар.Значение.Товар,"Товар");
			
			ТоварПол = ПроверкаНаНаличие(ДанныеТовара);
			
			СтрокТовар = ТабЧастьТовары.Добавить();
			СтрокТовар.Товар = ТоварПол;
			СтрокТовар.Количество = СтрукТовар.Значение.Количество; 
						
		КонецЦикла;
		
		ДанныеПисьма = Новый Структура("УИДПисьма,Номер,Дата,Договор,Контрагент,Товары,ТипЗаписи",
		ПрочитанноеСообщение.УИДПисьма,ПрочитанноеСообщение.НомерПисьма,ПрочитанноеСообщение.ДатаПисьма,Договор,Контрагент,ТабЧастьТовары,"Письмо");
		
		Письмо = ПроверкаНаНаличие(ДанныеПисьма);
	КонецЦикла;
    УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция ПроверкаНаНаличие(Данные) 
	
	Если Данные.ТипЗаписи = "Договор" Тогда
		Наличие = ЗапросПроверки(Данные.УИД);
		
		Если Наличие = ЛОЖЬ Тогда
			
			НовыйДоговор = Справочники.otus_Договор.СоздатьЭлемент();
			
			НовыйДоговор.Номер = Данные.НомерДоговора;
			НовыйДоговор.ДатаЗаключения = СтрокаДаты_ДД_ММ_ГГГГ_ВДату(Данные.ДатаЗаключения);
			НовыйДоговор.Контрагент = Данные.Контрагент;
			
			НовыйДоговор.Записать();
			
			СоответОб = Справочники.СоответствениеОбъектов.СоздатьЭлемент();
			
			СоответОб.УИДИсточника = Данные.УИД;
			СоответОб.СсылкаПриемника = НовыйДоговор.Ссылка;
			
			СоответОб.Записать();
			
			Возврат НовыйДоговор.Ссылка;
		Иначе
			
			Возврат Наличие;
			
		КонецЕсли;	
	ИначеЕсли Данные.ТипЗаписи = "Контрагент" Тогда
		
		Наличие = ЗапросПроверки(Данные.УИДКонтрагента);
		
		Если Наличие = ЛОЖЬ Тогда
			
			НовыйКонтрагент = Справочники.Контрагент.СоздатьЭлемент();
			
			НовыйКонтрагент.Наименование = Данные.Наименование;
			НовыйКонтрагент.Почта = Данные.Почта;
			НовыйКонтрагент.Телефон = Данные.Телефон;
			НовыйКонтрагент.Записать();
			
			СоответОб = Справочники.СоответствениеОбъектов.СоздатьЭлемент();
			
			СоответОб.УИДИсточника = Данные.УИДКонтрагента;
			СоответОб.СсылкаПриемника = НовыйКонтрагент.Ссылка;
			
			СоответОб.Записать();
			
			Возврат НовыйКонтрагент.Ссылка;
		Иначе
			
			Возврат Наличие;
			
		КонецЕсли;
		
	ИначеЕсли Данные.ТипЗаписи = "Товар" Тогда
		
		Наличие = ЗапросПроверки(Данные.УИДТовара);
		
		Если Наличие = ЛОЖЬ Тогда
			
			НовыйТовар = Справочники.Товар.СоздатьЭлемент();
			
			НовыйТовар.Наименование = Данные.Товар;
			НовыйТовар.Записать();
			
			СоответОб = Справочники.СоответствениеОбъектов.СоздатьЭлемент();
			
			СоответОб.УИДИсточника = Данные.УИДТовара;
			СоответОб.СсылкаПриемника = НовыйТовар.Ссылка;
			
			СоответОб.Записать();
			
			Возврат НовыйТовар.Ссылка;
			
		Иначе
			
			Возврат Наличие;
			
		КонецЕсли;
		
	 ИначеЕсли Данные.ТипЗаписи = "Письмо" Тогда
		
		Наличие = ЗапросПроверки(Данные.УИДПисьма);
		
		Если Наличие = ЛОЖЬ Тогда
			
			НовоеПисьмо = Документы.Письмо.СоздатьДокумент();
			
			НовоеПисьмо.Номер = Данные.Номер;
			НовоеПисьмо.Дата = СтрокаДаты_ДД_ММ_ГГГГ_ВДату(Данные.Дата); 
			НовоеПисьмо.Договор = Данные.Договор;
			НовоеПисьмо.Контрагент = Данные.Контрагент;
			
			НовоеПисьмо.Товары.Загрузить(Данные.Товары);
			
				НовоеПисьмо.Записать(РежимЗаписиДокумента.Запись);
			
			СоответОб = Справочники.СоответствениеОбъектов.СоздатьЭлемент();
			
			СоответОб.УИДИсточника = Данные.УИДПисьма;
			СоответОб.СсылкаПриемника = НовоеПисьмо.Ссылка;
			
			СоответОб.Записать();
			
			Возврат НовоеПисьмо.Ссылка;
		Иначе
			
			Возврат Наличие;
			
		КонецЕсли;

		
	КонецЕсли;
КонецФункции  

Функция СтрокаДаты_ДД_ММ_ГГГГ_ВДату(Строка)
    Д = Число(Сред(Строка, 1, 2));
    М = Число(Сред(Строка, 4, 2));
    Г = Число(Сред(Строка, 7, 4));
    Возврат Дата(Г, М, Д);
    
КонецФункции
	
&НаСервереБезКонтекста	
Функция ЗапросПроверки(УИД)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СоответствениеОбъектов.СсылкаПриемника КАК СсылкаПриемника
	               |ИЗ
	               |	Справочник.СоответствениеОбъектов КАК СоответствениеОбъектов
	               |ГДЕ
	               |	СоответствениеОбъектов.УИДИсточника = &УИДИсточника"; 
	
	Наличие = Ложь;
	
	Запрос.УстановитьПараметр("УИДИсточника",УИД);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		
		Ссылка = РезультатЗапроса.СсылкаПриемника;
		
		Возврат Ссылка;
		
	КонецЦикла;
	
	Возврат Наличие;
	
КонецФункции	

Функция ДанныеВJSON(Значение, Знач ПараметрыЗаписиJSON = Неопределено, НастройкиСериализации = Неопределено) Экспорт
	Если ПараметрыЗаписиJSON = Неопределено Тогда
		ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	КонецЕсли;
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON); 
	//ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Значение, НастройкиСериализации);
	Результат = ЗаписьJSON.Закрыть();    
	
	Возврат Результат;
КонецФункции

Функция ПрочитатьЗначениеJSON(ДанныеJSON, ИзФайла = Ложь, ПрочитатьВСоответствие = Ложь, ЗначениеПоУмолчанию = Неопределено, ОписаниеОшибки = "") Экспорт
	ЧтениеJSON = Новый ЧтениеJSON();
	
	Если ИзФайла = Истина Тогда
		ЧтениеJSON.ОткрытьФайл(ДанныеJSON);
	Иначе
		ЧтениеJSON.УстановитьСтроку(ДанныеJSON);
	КонецЕсли;
	
	Попытка
		Результат = ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
	Исключение
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Результат = ЗначениеПоУмолчанию;
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьНастройкиRabbitMQ_(ИспользоватьДляОтправкиДанных = Неопределено,ДанныеДляПодключения = Неопределено) Экспорт 
	
	Настройки = Новый Структура;
	Настройки.Вставить("RoutingKey","letter.*");
	Настройки.Вставить("ExchangeNode","OTUS_Test");
	Настройки.Вставить("HostName","192.168.0.112");
	Настройки.Вставить("UserName","admin");
	Настройки.Вставить("Password","Tgbhu890");
	Настройки.Вставить("Port","15672");
	Настройки.Вставить("VirtualHost","");
	Настройки.Вставить("QueueName","Base_1_Test_OTUS");
	Настройки.Вставить("RoutingKeyForErrors","");	
    Настройки.Вставить("ackmode","ack_requeue_false");
	
	Возврат Настройки;
КонецФункции 

&НаСервереБезКонтекста
Функция ОтправитьHTTPЗапрос(ПараметрыПодключения, АдресРесурса, Метод = "POST", ТекстJSON)

    Заголовки = Новый Соответствие;
    Заголовки.Вставить("content-type", "application/json");
    
    HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
    
    HTTPЗапрос.УстановитьТелоИзСтроки(ТекстJSON);
    
    АдресСервера    = ПараметрыПодключения.HostName;
    Логин            = ПараметрыПодключения.UserName;
    Пароль            = ПараметрыПодключения.Password;
    
    HTTPСоединение = Новый HTTPСоединение(АдресСервера, 15672, Логин, Пароль,, 60);
    
    Ответ = HTTPСоединение.ВызватьHTTPМетод(Метод, HTTPЗапрос);
    
    Возврат Ответ;
    
КонецФункции

&НаСервере
Функция ПолучитьФабрикуXDTO()

    // схема в макете обработки
    ТекстXSD = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Схема").ПолучитьТекст();
    
    // в случае встроенного в конфигурацию пакета XDTO необходимо использовать встроенную фабрику:
    // Возврат ФабрикаXDTO;
    
    ЧтениеXML = Новый ЧтениеXML;
    ЧтениеXML.УстановитьСтроку(ТекстXSD);

    ПостроительDOM = Новый ПостроительDOM;
    ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
    
    ПостроительСхем = Новый ПостроительСхемXML;
    СхемаXML = ПостроительСхем.СоздатьСхемуXML(ДокументDOM.ЭлементДокумента);

    НаборСхемXML = Новый НаборСхемXML;
    НаборСхемXML.Добавить(СхемаXML);
    
    Фабрика_XDTO = Новый ФабрикаXDTO(НаборСхемXML);    
    
    Возврат Фабрика_XDTO;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектXDTO_ПолучитьJSON(ОбъектXDTO, Фабрика_XDTO)
    
    ЗаписьJSON = Новый ЗаписьJSON;
    ЗаписьJSON.УстановитьСтроку();
    
    Фабрика_XDTO.ЗаписатьJSON(ЗаписьJSON, ОбъектXDTO, НазначениеТипаXML.Неявное); 
    
    ТекстJSON = ЗаписьJSON.Закрыть();
    
    // платформа помещает наш объект в свою структуру с ключом #value,
    // можем отдельно получить значение по ключу и еще раз сериализовать,
    // либо просто вырезать открывающий и закрывающий тег
    
    СтрокаТега1С = """#value"": {";
    
    ПозицияНачалоТега1С = СтрНайти(ТекстJSON, СтрокаТега1С);
    ПозицияКонецТега1С  = ПозицияНачалоТега1С + СтрДлина(СтрокаТега1С);
    
    ТекстJSON = Лев(ТекстJSON, ПозицияНачалоТега1С - 2) + Сред(ТекстJSON, ПозицияКонецТега1С + 1, СтрДлина(ТекстJSON) - ПозицияКонецТега1С - 1);
    
    Возврат ТекстJSON;

КонецФункции
