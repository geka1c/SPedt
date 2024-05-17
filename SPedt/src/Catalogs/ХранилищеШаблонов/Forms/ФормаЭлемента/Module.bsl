
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенник Тогда
		
	КонецЕсли;
	Если НЕ ПустаяСтрока(АдресШаблона) Тогда
		ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресШаблона));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ОбъектМетаданных.Доступность = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ТипШаблона) Тогда
		Элементы.ТипШаблона.Доступность = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокМетаданныхИспользующихШаблоны(Метаданные.Справочники);
	ЗаполнитьСписокМетаданныхИспользующихШаблоны(Метаданные.Документы);
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбъектЗначениеКопирования = Параметры.ЗначениеКопирования.ПолучитьОбъект();
		АдресШаблона = ПоместитьВоВременноеХранилище(ОбъектЗначениеКопирования.Шаблон.Получить(), УникальныйИдентификатор);
	Иначе
		ЭлементОбъект = РеквизитФормыВЗначение("Объект", Тип("СправочникОбъект.ХранилищеШаблонов"));
		АдресШаблона = ПоместитьВоВременноеХранилище(ЭлементОбъект.Шаблон.Получить(), УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.ТипШаблона) Тогда
		Элементы.ТипШаблона.Доступность = Ложь;
	КонецЕсли;
	Элементы.ОбъектМетаданных.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененШаблон" Тогда
		АдресШаблона = Параметр;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТипШаблонаПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормыПоТипуШаблона();
	Объект.ОбъектМетаданных = "";
	АдресШаблона = "";
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элементы.Наименование.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.ОбъектМетаданных) 
		И Элементы.ОбъектМетаданных.СписокВыбора.НайтиПоЗначению(Объект.ОбъектМетаданных) <> Неопределено
	Тогда
		СтрокаНаименования = Элементы.ОбъектМетаданных.СписокВыбора.НайтиПоЗначению(Объект.ОбъектМетаданных).Представление;
		Элементы.Наименование.СписокВыбора.Добавить("Чек " + СтрокаНаименования);
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуРедактированияМакета(Команда)
	// проверим тип и объект
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(,"Для редактирования шаблона необходимо записать элемент!");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.ТипШаблона) Тогда
		ПоказатьПредупреждение(,"Не указан тип шаблона!");
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОткрытия.Вставить("АдресШаблона", АдресШаблона);
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ФискальныйЧек") Тогда
		Если ПустаяСтрока(Объект.ОбъектМетаданных) Тогда
			ПоказатьПредупреждение(,"Не выбран объект метаданных!");
			Возврат;
		КонецЕсли;
		ПараметрыОткрытия.Вставить("ОбъектМетаданных", Объект.ОбъектМетаданных);
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблонаФискальногоЧека", ПараметрыОткрытия, ЭтаФорма);
	ИначеЕсли Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенник") Тогда
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников", ПараметрыОткрытия, ЭтаФорма);
	Иначе
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьСписокМетаданныхИспользующихШаблоны(КоллекцияМетаданных)
	
	Для Каждого МетаданныеОбъекта Из КоллекцияМетаданных Цикл
		Для Каждого Макет Из МетаданныеОбъекта.Макеты Цикл
			Если ВРег(Макет.Имя) = ВРег("ПоляШаблона") Тогда
				Элементы.ОбъектМетаданных.СписокВыбора.Добавить(МетаданныеОбъекта.ПолноеИмя(), МетаданныеОбъекта.Представление());
				прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Элементы.ОбъектМетаданных.СписокВыбора.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормыПоТипуШаблона()
	
	Элементы.ОбъектМетаданных.Доступность = Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ФискальныйЧек");
	
КонецПроцедуры
