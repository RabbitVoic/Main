﻿#language: ru

@tree

Функционал: Выполнение функционала

 

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: <описание сценария>
// Создание заявок
И В командном интерфейсе я выбираю 'OTUS' 'Otus заявка'
Когда открылось окно 'Otus заявка'
И я нажимаю на кнопку с именем 'ФормаСоздать'
Тогда открылось окно 'Otus заявка (создание)'
И из выпадающего списка с именем "Контрагент" я выбираю по строке 'Магазин телефонов'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Договор" я выбираю по строке 'Договор на телефоны 1'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Статус" я выбираю по строке 'Утверждена'
И я перехожу к следующему реквизиту
И в таблице "Товары" я нажимаю на кнопку с именем 'ТоварыДобавить'
И в таблице "Товары" из выпадающего списка с именем "ТоварыТовар" я выбираю по строке 'Телефон LG'
И я перехожу к следующему реквизиту
И в таблице "Товары" в поле с именем 'ТоварыКоличество' я ввожу текст '5'
И в таблице "Товары" я завершаю редактирование строки
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus заявка * от *' в течение 20 секунд
Тогда открылось окно 'Otus заявка'
И я нажимаю на кнопку с именем 'ФормаСоздать'
Тогда открылось окно 'Otus заявка (создание)'
И из выпадающего списка с именем "Контрагент" я выбираю по строке 'Магазин телевизоров'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Договор" я выбираю по строке 'Договор на телевизоры 2'
И я перехожу к следующему реквизиту
И я нажимаю кнопку выбора у поля с именем "Статус"
И из выпадающего списка с именем "Статус" я выбираю по строке 'Утверждена'
И я перехожу к следующему реквизиту
И в таблице "Товары" я нажимаю на кнопку с именем 'ТоварыДобавить'
И в таблице "Товары" из выпадающего списка с именем "ТоварыТовар" я выбираю по строке 'Телевизор LG'
И я перехожу к следующему реквизиту
И в таблице "Товары" я активизирую поле с именем "ТоварыТовар"
И в таблице "Товары" из выпадающего списка с именем "ТоварыТовар" я выбираю точное значение 'Телевизор LG'
И я перехожу к следующему реквизиту
И в таблице "Товары" в поле с именем 'ТоварыКоличество' я ввожу текст '4'
И в таблице "Товары" я завершаю редактирование строки
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus заявка (создание) *' в течение 20 секунд
Тогда открылось окно 'Otus заявка'
И я нажимаю на кнопку с именем 'ФормаСоздать'
Тогда открылось окно 'Otus заявка (создание)'
И из выпадающего списка с именем "Контрагент" я выбираю по строке 'магазин техники'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Договор" я выбираю по строке 'Договор на телевизоры 3'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Статус" я выбираю по строке 'Утверждена'
И я перехожу к следующему реквизиту
И в таблице "Товары" я нажимаю на кнопку с именем 'ТоварыДобавить'
И в таблице "Товары" из выпадающего списка с именем "ТоварыТовар" я выбираю по строке 'Телевизор LG'
И я перехожу к следующему реквизиту
И в таблице "Товары" в поле с именем 'ТоварыКоличество' я ввожу текст '6'
И в таблице "Товары" я завершаю редактирование строки
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus заявка (создание) *' в течение 20 секунд
// Оформление заявок
И В командном интерфейсе я выбираю 'OTUS' 'Otus АРМ менеджера'
Тогда открылось окно 'Otus АРМ менеджера'
И в таблице "СписокЗаявок" я активизирую поле с именем "СписокЗаявокПометка"
И в таблице "СписокЗаявок" я изменяю флаг с именем 'СписокЗаявокПометка'
И в таблице "СписокЗаявок" я завершаю редактирование строки
И в таблице "СписокЗаявок" я перехожу к строке:
	| 'Пометка' |
	| 'Нет'     |
И в таблице "СписокЗаявок" я изменяю флаг с именем 'СписокЗаявокПометка'
И в таблице "СписокЗаявок" я завершаю редактирование строки
И в таблице "СписокЗаявок" я перехожу к строке:
	| 'Пометка' |
	| 'Нет'     |
И в таблице "СписокЗаявок" я изменяю флаг с именем 'СписокЗаявокПометка'
И в таблице "СписокЗаявок" я завершаю редактирование строки
И в таблице "СписокЗаявок" я нажимаю на кнопку с именем 'СписокЗаявокОформить'
И в таблице "СписокЗаявок" я нажимаю на кнопку с именем 'СписокЗаявокОбновить'


// Открытие актов и выбор склада
И В командном интерфейсе я выбираю 'OTUS' 'Otus акт передачи товара'
Тогда открылось окно 'Otus акт передачи товара'
И в таблице "Список" я перехожу к строке:
| 'Статус'      |
| 'Формируется' |
И в таблице "Список" я выбираю текущую строку
Тогда открылось окно 'Otus акт передачи товара * от *'
И из выпадающего списка с именем "Склад" я выбираю точное значение 'Большой'
И из выпадающего списка с именем "Склад" я выбираю по строке 'Большой'
Когда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю на кнопку с именем 'ФормаПровести'
Тогда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus акт передачи товара * от *' в течение 20 секунд
Тогда открылось окно 'Otus акт передачи товара'
И в таблице "Список" я перехожу к строке:
	| 'Статус'      |
	| 'Формируется' |
И в таблице "Список" я выбираю текущую строку
Тогда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю кнопку выбора у поля с именем "Склад"
И из выпадающего списка с именем "Склад" я выбираю по строке 'Малый'
Когда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю на кнопку с именем 'ФормаПровести'
Тогда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus акт передачи товара * от *' в течение 20 секунд
Тогда открылось окно 'Otus акт передачи товара'
И в таблице "Список" я перехожу к строке:
	| 'Статус'      |
	| 'Формируется' |
И в таблице "Список" я выбираю текущую строку
Тогда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю кнопку выбора у поля с именем "Склад"
И из выпадающего списка с именем "Склад" я выбираю по строке 'Большой'
Когда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю на кнопку с именем 'ФормаПровести'
Тогда открылось окно 'Otus акт передачи товара * от *'
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus акт передачи товара * от *' в течение 20 секунд
//Оформление возврата
И В командном интерфейсе я выбираю 'OTUS' 'Otus возврат товара'
Тогда открылось окно 'Otus возврат товара'
И я нажимаю на кнопку с именем 'ФормаСоздать'
Тогда открылось окно 'Otus возврат товара (создание)'
И из выпадающего списка с именем "Контрагент" я выбираю по строке 'Магазин телевизоров'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Склад" я выбираю по строке 'Малый'
И я перехожу к следующему реквизиту
И в поле с именем 'АктПередачи' я ввожу текст ''
И я нажимаю кнопку выбора у поля с именем "АктПередачи"
Тогда открылось окно 'Otus акт передачи товара'
И в таблице "Список" я активизирую поле с именем "Номер"
И в таблице "Список" я выбираю текущую строку
Тогда открылось окно 'Otus возврат товара (создание) *'
И в таблице "СписокТоваров" я нажимаю на кнопку с именем 'СписокТоваровДобавить'
И в таблице "СписокТоваров" из выпадающего списка с именем "СписокТоваровТовар" я выбираю точное значение 'Телевизор LG'
И я перехожу к следующему реквизиту
И в таблице "СписокТоваров" в поле с именем 'СписокТоваровКоличество' я ввожу текст '6'
И в таблице "СписокТоваров" я завершаю редактирование строки
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Otus возврат товара (создание) *' в течение 20 секунд
//Выполнение обмена
И В командном интерфейсе я выбираю 'OTUS' 'Otus АРМ контрольной службы'
Тогда открылось окно 'Otus АРМ контрольной службы'
И в таблице "СрокПросрочен" я нажимаю на кнопку с именем 'СрокПросроченСоздатьПисьмо'
И в таблице "СрокПросрочен" я нажимаю на кнопку с именем 'СрокПросроченОбновить'
И я перехожу к закладке с именем "Группа3"
И В командном интерфейсе я выбираю 'OTUS' 'Otus обмен со второй базой'
Тогда открылось окно 'Otus обмен со второй базой'
И я нажимаю на кнопку с именем 'ФормаВыполнитьОбмен'
И В командном интерфейсе я выбираю 'OTUS' 'Otus АРМ контрольной службы'
Тогда открылось окно 'Otus АРМ контрольной службы'
И в таблице "ИнформацияПоПисьмам" я нажимаю на кнопку с именем 'ИнформацияПоПисьмамОбновитьПисьма'







