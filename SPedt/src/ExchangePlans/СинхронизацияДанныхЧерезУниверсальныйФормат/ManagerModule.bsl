#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает строковое представление варианта синхронизации документов,
// в зависимости от установленного режима выгрузки документов; 
//
// Параметры:
//  РежимВыгрузкиДокументов - ПеречислениеСсылка.РежимыВыгрузкиОбъектовОбмена - режим выгрузки документов.
//
// Возвращаемое значение:
//  Строка - строковое представление варианта выгрузки документов.
//
Функция ОпределитьВариантСинхронизацииДокументов(РежимВыгрузкиДокументов) Экспорт
	
	ВариантСинхронизацииДокументов = "";
	
	Если РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииДокументов = "АвтоматическаяСинхронизация"
		
	ИначеЕсли РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		
		ВариантСинхронизацииДокументов = "ИнтерактивнаяСинхронизация"
		
	ИначеЕсли РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		ВариантСинхронизацииДокументов = "НеСинхронизировать"
		
	КонецЕсли;
	
	Возврат ВариантСинхронизацииДокументов;
	
КонецФункции

// Возвращает строковое представление варианта синхронизации справочников,
// в зависимости от установленного режима выгрузки справочников; 
//
// Параметры:
//  РежимВыгрузкиСправочников - ПеречислениеСсылка.РежимыВыгрузкиОбъектовОбмена - режим выгрузки справочников.
//
// Возвращаемое значение:
//  Строка - строковое представление варианта выгрузки справочников.
//
Функция ОпределитьВариантСинхронизацииСправочников(РежимВыгрузкиСправочников) Экспорт
	
	ВариантСинхронизацииСправочников = "";
	
	Если РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииСправочников = "АвтоматическаяСинхронизация";
		
	ИначеЕсли РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости Тогда
		
		ВариантСинхронизацииСправочников = "СинхронизироватьПоНеобходимости";
		
	ИначеЕсли РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		ВариантСинхронизацииСправочников = "НеСинхронизировать";
		
	КонецЕсли;
	
	Возврат ВариантСинхронизацииСправочников;
	
КонецФункции

// Возвращает список организаций по таблице отбора (см "ПредставлениеОтбораИнтерактивнойВыгрузки").
// Также используется из демонстрационной формы "НастройкаВыгрузки" этого плана обмена.
//
// Параметры:
//     ТаблицаОтбора - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла. Содержит
//                                         колонки:
//         ПолноеИмяМетаданных - Строка
//         ВыборПериода        - Булево
//         Период              - СтандартныйПериод
//         Отбор               - ОтборКомпоновкиДанных.
//
// Возвращаемое значение:
//     СписокЗначений - значение - ссылка на организацию, представление - наименование.
//
Функция ОрганизацииОтбораИнтерактивнойВыгрузки(Знач ТаблицаОтбора) Экспорт 
	
	Результат = Новый СписокЗначений;
	
	//Если ТаблицаОтбора.Количество()=0 Или ТаблицаОтбора[0].Отбор.Элементы.Количество()=0 Тогда
	//	// Нет данных отбора
	//	Возврат Результат;
	//КонецЕсли;
	//	
	//// Мы знаем состав отбора, так как помещали туда сами - или из "НастроитьИнтерактивнуюВыгрузку"
	//// или как результат редактирования в форме.
	//
	//СтрокаДанных = ТаблицаОтбора[0].Отбор.Элементы[0];
	//Отобранные   = СтрокаДанных.ПравоеЗначение;
	//ТипКоллекции = ТипЗнч(Отобранные);
	//
	//Если ТипКоллекции = Тип("СписокЗначений") Тогда
	//	Для Каждого Элемент Из Отобранные Цикл
	//		ДобавитьСписокОрганизаций(Результат, Элемент.Значение);
	//	КонецЦикла;
	//	
	//ИначеЕсли ТипКоллекции = Тип("Массив") Тогда
	//	ДобавитьСписокОрганизаций(Результат, Отобранные);
	//	 
	//ИначеЕсли ТипКоллекции = Тип("СправочникСсылка._ДемоОрганизации") Тогда
	//	Если Результат.НайтиПоЗначению(Отобранные)=Неопределено Тогда
	//		Результат.Добавить(Отобранные, Отобранные.Наименование);
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	Возврат Результат;
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	// В демонстрационной конфигурации значение хранится в константе
	// _ДемоИмяКонфигурацииВОбменеСБиблиотекойСтандартныхПодсистем.
	// Это связано с необходимостью настройки обмена между идентичными конфигурациями "БСП-БСП".
	// Для настройки обмена между различными конфигурациями функция должна возвращать константное значение.
	
	Настройки.ИмяКонфигурацииИсточника = Метаданные.Имя;
		
	Настройки.ЭтоПланОбменаXDTO = Истина;
	Настройки.ФорматОбмена = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData";
	
	ВерсииФормата = Новый Соответствие;
	ВерсииФормата.Вставить("1.2", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.3", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.4", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.5", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.6", МенеджерОбменаЧерезУниверсальныйФормат);
	
	Настройки.ВерсииФорматаОбмена = ВерсииФормата;
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена   = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
	Настройки.Алгоритмы.ПредставлениеОтбораИнтерактивнойВыгрузки = Истина;
	Настройки.Алгоритмы.НастроитьИнтерактивнуюВыгрузку           = Истина;
	
	Настройки.Алгоритмы.ОбработчикПроверкиПараметровУчета           = Истина;
	Настройки.Алгоритмы.ОбработчикПроверкиОграниченийПередачиДанных = Истина;
	Настройки.Алгоритмы.ОбработчикПроверкиЗначенийПоУмолчанию       = Истина;
	
	Настройки.Алгоритмы.ПриПодключенииККорреспонденту     = Истина;
	
	Настройки.Алгоритмы.ПриОпределенииПоддерживаемыхОбъектовФормата = Истина;
	Настройки.Алгоритмы.ПриОпределенииПоддерживаемыхКорреспондентомОбъектовФормата = Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыКонтекста.ИмяКорреспондента)
		Или ПараметрыКонтекста.ИмяКорреспондента = "БиблиотекаСтандартныхПодсистемДемо" Тогда
		ВариантНастройки = ВариантыНастроекОбмена.Добавить();
		ВариантНастройки.ИдентификаторНастройки        = "БСП";
		ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
		ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	КонецЕсли;
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = "";
	ИмяКонфигурацииКорреспондента = "";
	НаименованиеКонфигурацииКорреспондента = "";
	
	ЗаголовокКоманды   = НСтр("ru = 'Синхронизация данных через универсальный формат'");
	ЗаголовокПомощника = "";
	ЗаголовокУзла      = "";
	
	Если ИдентификаторНастройки = "БСП" Тогда
		ИмяКонфигурацииКорреспондента          = Метаданные.Имя;
		НаименованиеКонфигурацииКорреспондента = НСтр("ru = '1С:Библиотека стандартных подсистем'");
		
		КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет синхронизировать данные между двумя однотипными программами 1С:Библиотека стандартных подсистем через универсальный формат EnterpriseData.
		|В синхронизации данных участвуют следующие типы данных:
		| - справочники (например, Организации),
		| - документы (например, Реализация товаров).'");
		
		ЗаголовокКоманды   = НСтр("ru = 'Полная синхронизация данных с ""1С:Библиотека стандартных подсистем"" через EnterpriseData'");
		ЗаголовокПомощника = НСтр("ru = 'Синхронизация данных с 1С:Библиотека стандартных подсистем (настройка)'");
		ЗаголовокУзла      = НСтр("ru = 'Синхронизация данных с 1С:Библиотека стандартных подсистем'");
	Иначе
		// Другая программа.
		ИмяКонфигурацииКорреспондента          = "";
		НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Другая программа'");
		
		КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет синхронизировать данные с любой программой, поддерживающей универсальный формат обмена ""Enterprise Data"".
		|В синхронизации данных участвуют следующие типы данных:
		| - справочники (например, Организации),
		| - документы (например, Реализация товаров).'");
	КонецЕсли;
	КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену;
	
	ПодробнаяИнформацияПоОбмену = "ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену;
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента          = ИмяКонфигурацииКорреспондента;
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НаименованиеКонфигурацииКорреспондента;
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника           = НСтр("ru = 'Синхронизация данных через универсальный формат'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = ЗаголовокКоманды;
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена               = ЗаголовокПомощника;
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена                       = ЗаголовокУзла;
	
	ПояснениеДляНастройкиПараметровУчета = НСтр("ru = 'Требуется указать ответственных для организаций.
	|Для этого перейдите в раздел ""Синхронизация данных"" и выберите команду ""Ответственные лица организаций"".'");
	ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = ПояснениеДляНастройкиПараметровУчета;

КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку".
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора.
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                        узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут
//                                                               быть использованы специальные  значения "ВсеДокументы"
//                                                               и "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с
//                                                               общим правилами формирования полей компоновки.
//                                                               Например, для указания отбора по реквизиту документа
//                                                               "Организация", будет использовано поле
//                                                               "Ссылка.Организация".
//
// Возвращаемое значение: 
//     Строка - описание отбора.
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	//Если Параметры.ИспользоватьПериодОтбора Тогда
	//	Если ЗначениеЗаполнено(Параметры.ПериодОтбора) Тогда
	//		ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='за период: %1'"), НРег(Параметры.ПериодОтбора));
	//	Иначе
	//		ДатаНачалаВыгрузки = Получатель.ДатаНачалаВыгрузкиДокументов;
	//		Если ЗначениеЗаполнено(ДатаНачалаВыгрузки) Тогда
	//			ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//				НСтр("ru='начиная с даты начала отправки документов: %1'"), Формат(ДатаНачалаВыгрузки, "ДЛФ=DD"));
	//		Иначе
	//			ОписаниеПериода = НСтр("ru='за весь период учета'");
	//		КонецЕсли;
	//	КонецЕсли;
	//Иначе
	//	ОписаниеПериода = "";
	//КонецЕсли;
	//
	//СписокОрганизаций = ОрганизацииОтбораИнтерактивнойВыгрузки(Параметры.Отбор);
	//Если СписокОрганизаций.Количество()=0 Тогда
	//	ОписаниеОтбораОрганизации = НСтр("ru='по всем организациям'");
	//Иначе
	//	ОписаниеОтбораОрганизации = "";
	//	Для Каждого Элемент Из СписокОрганизаций Цикл
	//		ОписаниеОтбораОрганизации = ОписаниеОтбораОрганизации+ ", " + Элемент.Представление;
	//	КонецЦикла;
	//	ОписаниеОтбораОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='по организациям: %1'"), СокрЛП(Сред(ОписаниеОтбораОрганизации, 2)));
	//КонецЕсли;

	//Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//	НСтр("ru='Будут отправлены поступления товаров %1,
	//	         |%2'"),
	//	ОписаниеПериода,  ОписаниеОтбораОрганизации); 
	Возврат "";
КонецФункции

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху
//                                                            вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Строка            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Строка            - Заголовок для отрисовки на форме команды открытия формы
//                                                            настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По
//                                                            умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по
//                                                            умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                            узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно
//                                                               использовать специальные  значения "ВсеДокументы" и
//                                                               "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки,
//                                                               предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в
//                                                               соответствии с общим правилами формирования полей
//                                                               компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле
//                                                               "Ссылка.Организация".
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	//// Настраиваем стандартные варианты.
	//Параметры.ВариантБезДополнения.Использование     = Истина;
	//Параметры.ВариантБезДополнения.Порядок           = 2;
	//Параметры.ВариантВсеДокументы.Использование      = Ложь;
	//Параметры.ВариантПроизвольныйОтбор.Использование = Истина;
	//
	//// Настраиваем вариант дополнения по сценарию узла.
	//Параметры.ВариантДополнительно.Использование  = Истина;
	//Параметры.ВариантДополнительно.Порядок        = 1;
	//Параметры.ВариантДополнительно.Заголовок      = НСтр("ru='Отправить поступления товаров по организациям:'");
	//Параметры.ВариантДополнительно.Пояснение      = НСтр("ru='Дополнительно будут отправлены документы поступления товаров за указанный период по выбранным организациям.'");
	//
	//Параметры.ВариантДополнительно.ИмяФормыОтбора        = "ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.НастройкаВыгрузки";
	//Параметры.ВариантДополнительно.ЗаголовокКомандыФормы = НСтр("ru='Выбрать организации'");
	//
	//// Вычисляем и устанавливаем параметры сценария.
	//ПараметрыПоУмолчанию = ПараметрыВыгрузкиПоУмолчанию(Получатель);
	//
	//Параметры.ВариантДополнительно.ИспользоватьПериодОтбора = Истина;
	//Параметры.ВариантДополнительно.ПериодОтбора = ПараметрыПоУмолчанию.Период;
	//
	//// Добавляем строку настройки отбора.
	//СтрокаОтбора = Параметры.ВариантДополнительно.Отбор.Добавить();
	//СтрокаОтбора.ПолноеИмяМетаданных = "Документ._ДемоПоступлениеТоваров";
	//СтрокаОтбора.ВыборПериода = Истина;
	//СтрокаОтбора.Период       = ПараметрыПоУмолчанию.Период;
	//СтрокаОтбора.Отбор        = ПараметрыПоУмолчанию.Отбор;
	
КонецПроцедуры

// Проверяет корректность настройки параметров учета.
//
// Параметры:
//	Отказ - Булево - Признак невозможности продолжения настройки обмена из-за некорректно настроенных параметров учета.
//	Получатель - ПланОбменаСсылка - Узел обмена, для которого выполняется проверка параметров учета.
//	Сообщение - Строка - Содержит текст сообщения о некорректных параметрах учета.
//
Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	Отбор = Неопределено;
	
	//СвойстваПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, "ИспользоватьОтборПоОрганизациям, Организации");
	//
	//Если СвойстваПолучателя.ИспользоватьОтборПоОрганизациям Тогда
	//	
	//	Отбор = СвойстваПолучателя.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
	//	
	//КонецЕсли;
	//
	//Если Не РегистрыСведений._ДемоОтветственныеЛица.ДляВсехОрганизацийНазначеныОтветственные(Отбор, Сообщение) Тогда
	//	
	//	Отказ = Истина;
	//	
	//КонецЕсли;
	
КонецПроцедуры

// Проверяет заполненность на узле ограничений передачи данных, необходимых для корректного 
// формирования сообщения обмена. Используется только для планов обмена XDTO.
// Выполняется перед началом формирования сообщения обмена для корреспондента.
//
// Параметры:
//  Отказ - Булево - признак, что настройки ограничений на узле не соответствуют настройкам обмена.
//  ПараметрыОбработчика - Структура - параметры для выполнения проверки.
//    * Корреспондент - ПланОбменаОбъект - узел плана обмена, соответствующий корреспонденту.
//    * ПоддерживаемыеОбъектыXDTO - Массив - содержит перечень объектов формата, которые могут быть приняты корреспондентом,
//                                       и отправка которых поддерживается в этой базе.
//  СообщениеОбОшибке - Строка - содержит текст о некорректно заполненных (не заполненных) ограничениях.
//
Процедура ОбработчикПроверкиОграниченийПередачиДанных(Отказ, ПараметрыОбработчика, СообщениеОбОшибке = "") Экспорт
	
	
КонецПроцедуры

// Проверяет заполненность на узле значений по умолчанию, необходимых для корректной 
// загрузки сообщения обмена. Используется только для планов обмена XDTO.
// Выполняется перед началом загрузки сообщения обмена, полученного от корреспондента.
//
// Параметры:
//  Отказ - Булево - признак, что на узле обмена заполнены не все значения по умолчанию.
//  ПараметрыОбработчика - Структура - параметры для выполнения проверки.
//    * Корреспондент - ПланОбменаОбъект - узел плана обмена, соответствующий корреспонденту.
//    * ПоддерживаемыеОбъектыXDTO - Массив - содержит перечень объектов формата, которые могут быть отправлены корреспондентом,
//                                       и получение которых поддерживается в этой базе.
//  СообщениеОбОшибке - Строка - сообщение об ошибке, которое будет фиксироваться в протоколе выполнения обмена.
//
Процедура ОбработчикПроверкиЗначенийПоУмолчанию(Отказ, ПараметрыОбработчика, СообщениеОбОшибке = "") Экспорт
	
	
КонецПроцедуры

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
// Параметры:
//	ВерсияКорреспондента - Строка - версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
	//Если ВерсияКорреспондента = "0.0.0.0" Тогда
	//	ВерсияКорреспондента = "2.0.1.1";
	//КонецЕсли;
	//
	//Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияКорреспондента, "1.0.6.8") < 0 Тогда
	//	ВызватьИсключение НСтр("ru = 'Настройка синхронизации данных поддерживается только с демонстрационной конфигурацией
	//		|""Библиотека стандартных подсистем"" версии 1.0.6 и выше.'");
	//КонецЕсли;
	//
КонецПроцедуры

// Вызывается после определения состава поддерживаемых этой конфигурацией объектов формата.
// Предоставляет возможность дополнить или ограничить состав данных, которые могут участвовать в обмене.
// Используется только для планов обмена XDTO.
//
// Параметры:
//  ПоддерживаемыеОбъекты - ТаблицаЗначений - см. ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФормата.
//  Режим                 - Строка - см. описание одноименного параметра функции ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФормата.
//  УзелОбмена            - ПланОбменаСсылка - узел плана обмена, соответствующий корреспонденту.
//
Процедура ПриОпределенииПоддерживаемыхОбъектовФормата(ПоддерживаемыеОбъекты, Режим, УзелОбмена = Неопределено) Экспорт
	
	
КонецПроцедуры

// Вызывается после определения состава поддерживаемых конфигурацией-корреспондентом объектов формата.
// Предоставляет возможность дополнить или ограничить состав данных, которые могут участвовать в обмене.
// Используется только для планов обмена XDTO.
//
// Параметры:
//  УзелОбмена            - ПланОбменаСсылка - узел плана обмена, соответствующий корреспонденту.
//  ПоддерживаемыеОбъекты - ТаблицаЗначений - см. ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФорматаКорреспондента.
//  Режим                 - Строка - см. описание одноименного параметра функции ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФорматаКорреспондента.
//
Процедура ПриОпределенииПоддерживаемыхКорреспондентомОбъектовФормата(УзелОбмена, ПоддерживаемыеОбъекты, Режим) Экспорт
	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Расчет параметров выгрузки по умолчанию.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//
// Возвращаемое значение - Структура - содержит поля:
//     ПредставлениеОтбора - Строка - текстовое описание отбора по умолчанию.
//     Период              - СтандартныйПериод     - значение периода общего отбора по умолчанию.
//     Отбор               - ОтборКомпоновкиДанных - отбор.
//
Функция ПараметрыВыгрузкиПоУмолчанию(Получатель)
	
	Результат = Новый Структура;
	
	//// Период по умолчанию
	//Результат.Вставить("Период", Новый СтандартныйПериод);
	//Результат.Период.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
	//
	//// Отбор по умолчанию и его представление.
	//КомпоновщикОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	//Результат.Вставить("Отбор", КомпоновщикОтбора.Настройки.Отбор);
	//
	//ОтборПоОрганизации = Результат.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ОтборПоОрганизации.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка.Организация");
	//ОтборПоОрганизации.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	//ОтборПоОрганизации.Использование  = Истина;
	//ОтборПоОрганизации.ПравоеЗначение = Новый Массив;
	//
	//// Элементы, предлагаемые первый раз по умолчанию, считываем из настроек узла.
	//Если Получатель.ИспользоватьОтборПоОрганизациям Тогда
	//	// Организации из табличной части.
	//	ЗапросИсточника = Новый Запрос("
	//		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//		|	ОрганизацииПланаОбмена.Организация              КАК Организация,
	//		|	ОрганизацииПланаОбмена.Организация.Наименование КАК Наименование
	//		|ИЗ
	//		|	ПланОбмена._ДемоСинхронизацияДанныхЧерезУниверсальныйФормат.Организации КАК ОрганизацииПланаОбмена
	//		|ГДЕ
	//		|	ОрганизацииПланаОбмена.Ссылка = &Получатель
	//		|");
	//	ЗапросИсточника.УстановитьПараметр("Получатель", Получатель);
	//Иначе
	//	// Все доступные организации
	//	ЗапросИсточника = Новый Запрос("
	//		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//		|	Организации.Ссылка       КАК Организация,
	//		|	Организации.Наименование КАК Наименование
	//		|ИЗ
	//		|	Справочник._ДемоОрганизации КАК Организации
	//		|ГДЕ
	//		|	НЕ Организации.ПометкаУдаления
	//		|");
	//КонецЕсли;
	//	
	//ОтборПоОрганизацииСтрокой = "";
	//Выборка = ЗапросИсточника.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	ОтборПоОрганизации.ПравоеЗначение.Добавить(Выборка.Организация);
	//	ОтборПоОрганизацииСтрокой = ОтборПоОрганизацииСтрокой + ", " + Выборка.Наименование;
	//КонецЦикла;
	//ОтборПоОрганизацииСтрокой = СокрЛП(Сред(ОтборПоОрганизацииСтрокой, 2));
	//
	//// Общее представление, период не включаем, так как в этом сценарии поле периода будет редактироваться отдельно.
	//Результат.Вставить("ПредставлениеОтбора", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//	НСтр("ru='Будут отправлены поступления товаров по организациям:
	//	         |%1'"),
	//	ОтборПоОрганизацииСтрокой));
	
	Возврат Результат;
КонецФункции

// Добавляет в список организаций выбранную коллекцию.
//
// Параметры:
//     Список      - СписокЗначений - дополняемый список.
//     Организации - Коллекция организаций.
// 
//Процедура ДобавитьСписокОрганизаций(Список, Знач Организации)
//	Для Каждого Организация Из Организации Цикл
//		
//		Если ТипЗнч(Организация)=Тип("Массив") Тогда
//			ДобавитьСписокОрганизаций(Список, Организация);
//			Продолжить;
//		КонецЕсли;
//		
//		Если Список.НайтиПоЗначению(Организация)=Неопределено Тогда
//			Список.Добавить(Организация, Организация.Наименование);
//		КонецЕсли;
//		
//	КонецЦикла;
//КонецПроцедуры

#КонецОбласти

#КонецЕсли
