#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	Контекст.Вставить("ПолныеПраваНаВарианты", ВариантыОтчетов.ПолныеПраваНаВарианты());
	
	ПрототипКлюч = Параметры.КлючТекущихНастроек;
	
	ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(Параметры.КлючОбъекта);
	Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
		ВызватьИсключение ОтчетИнформация.ТекстОшибки;
	КонецЕсли;
	Контекст.Вставить("ОтчетСсылка", ОтчетИнформация.Отчет);
	Контекст.Вставить("ОтчетИмя",    ОтчетИнформация.ОтчетИмя);
	Контекст.Вставить("ТипОтчета",   ОтчетИнформация.ТипОтчета);
	Контекст.Вставить("ЭтоВнешний",  ОтчетИнформация.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Контекст.Вставить("ПоискПоНаименованию", Новый Соответствие);
	
	ЗаполнитьСписокВариантов(Ложь);
	
	Элементы.ГруппаДоступен.ТолькоПросмотр = Не Контекст.ПолныеПраваНаВарианты;
	Если Контекст.ЭтоВнешний Тогда
		Элементы.ОписаниеВнешнегоОтчета.Видимость = Истина;
		Элементы.ВариантВидимостьПоУмолчанию.Видимость = Ложь;
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		Элементы.ГруппаДоступен.Видимость = Ложь;
		УдалитьВторуюСтрокуВЗаголовке(Элементы.ДекорацияЧтоБудетДальшеНовый.Заголовок);
		УдалитьВторуюСтрокуВЗаголовке(Элементы.ДекорацияЧтоБудетДальшеПерезапись.Заголовок);
	КонецЕсли;
	
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Не ЗначениеЗаполнено(ВариантНаименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Наименование"" не заполнено'"),
			,
			"Наименование");
		Отказ = Истина;
	ИначеЕсли ВариантыОтчетов.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, ВариантНаименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" занято, необходимо указать другое Наименование.'"),
				ВариантНаименование),
			,
			"Наименование");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник = ИмяФормы Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта()
		Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВариантов(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекущийЭлемент = Элементы.Наименование;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НаименованиеМодифицировано = Истина;
	Элементы.ВариантыОтчета.ТекущаяСтрока = Контекст.ПоискПоНаименованию.Получить(ВариантНаименование);
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	ВариантТолькоДляАвтора = (Доступен = "ТолькоАвтор");
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ОписаниеНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элементы.Описание.ТекстРедактирования,
		НСтр("ru = 'Описание'"));
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	ОписаниеМодифицировано = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыОтчета

&НаКлиенте
Процедура ВариантыОтчетаПриАктивизацииСтроки(Элемент)
	НаименованиеМодифицировано = Ложь;
	ОписаниеМодифицировано = Ложь;
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СохранитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьВариантДляИзменения();
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	Вариант = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Контекст.ПолныеПраваНаВарианты И Не Вариант.АвторТекущийПользователь Тогда
		ТекстПредупреждения = НСтр("ru = 'Недостаточно прав для удаления варианта отчета ""%1"".'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если Не Вариант.Пользовательский Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно удалить предопределенный вариант отчета.'"));
		Возврат;
	КонецЕсли;
	
	Если Вариант.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
	КонецЕсли;
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Вариант.Наименование);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Идентификатор", Вариант.ПолучитьИдентификатор());
	Обработчик = Новый ОписаниеОповещения("ВариантыОтчетаПередУдалениемЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да); 
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередУдалениемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьВариантНаСервере(ДополнительныеПараметры.Идентификатор);
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	ПерейтиНаСтраницу1();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",       Истина);
	Пакет.Вставить("ПерейтиНаСтраницу2",       Истина);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Истина);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Ложь);
	Пакет.Вставить("ЗакрытьПослеЗаписи",       Ложь);
	Пакет.Вставить("ТекущийШаг", Неопределено);
	
	ВыполнитьПакет(Неопределено, Пакет);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыОтчета.Пользовательский");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
 
 	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПолныеПраваНаВарианты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыОтчета.АвторТекущийПользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);
	
 	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыОтчета.Порядок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 3;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
	ВариантыОтчетов.УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ВыполнитьПакет(Результат, Пакет) Экспорт
	Если Не Пакет.Свойство("ВариантЭтоНовый") Тогда
		Пакет.Вставить("ВариантЭтоНовый", Не ЗначениеЗаполнено(ВариантСсылка));
	КонецЕсли;
	
	// Обработка результата предыдущего шага.
	Если Пакет.ТекущийШаг = "ВопросНаПерезапись" Тогда
		Пакет.ТекущийШаг = Неопределено;
		Если Результат = КодВозвратаДиалога.Да Тогда
			Пакет.Вставить("ВопросНаПерезаписьПройден", Истина);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Выполнение следующего шага.
	Если Пакет.ПроверитьСтраницу1 = Истина Тогда
		// Наименование не введено.
		Если Не ЗначениеЗаполнено(ВариантНаименование) Тогда
			ТекстОшибки = НСтр("ru = 'Поле ""Наименование"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ВариантНаименование");
			Возврат;
		КонецЕсли;
		
		// Введено наименование существующего варианта отчета.
		Если Не Пакет.ВариантЭтоНовый Тогда
			Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Ссылка", ВариантСсылка));
			Вариант = Найденные[0];
			Если Не ПравоЗаписиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
				ТекстОшибки = НСтр("ru = 'Недостаточно прав для изменения варианта ""%1"". Необходимо выбрать другой вариант или изменить Наименование.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВариантНаименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ВариантНаименование");
				Возврат;
			КонецЕсли;
			
			Если Не Пакет.Свойство("ВопросНаПерезаписьПройден") Тогда
				Если Вариант.ПометкаУдаления = Истина Тогда
					ТекстВопроса = НСтр("ru = 'Вариант отчета ""%1"" помечен на удаление.
					|Заменить помеченный на удаление вариант отчета?'");
					КнопкаПоУмолчанию = КодВозвратаДиалога.Нет;
				Иначе
					ТекстВопроса = НСтр("ru = 'Заменить ранее сохраненный вариант отчета ""%1""?'");
					КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
				КонецЕсли;
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ВариантНаименование);
				Пакет.ТекущийШаг = "ВопросНаПерезапись";
				Обработчик = Новый ОписаниеОповещения("ВыполнитьПакет", ЭтотОбъект, Пакет);
				ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КнопкаПоУмолчанию);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		// Проверка завершена.
		Пакет.ПроверитьСтраницу1 = Ложь;
	КонецЕсли;
	
	Если Пакет.ПерейтиНаСтраницу2 = Истина Тогда
		// Для внешних отчетов выполняются только проверки заполнения, без переключения страницы.
		Если Не Контекст.ЭтоВнешний Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страница2;
			Элементы.Назад.Доступность        = Истина;
			Элементы.Далее.Доступность        = Ложь;
		КонецЕсли;
		
		// Переключение выполнено.
		Пакет.ПерейтиНаСтраницу2 = Ложь;
	КонецЕсли;
	
	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина
		Или Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		
		ВыполнитьПакетСервер(Пакет);
		
		СтрокиДерева = ДеревоПодсистем.ПолучитьЭлементы();
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			Элементы.ДеревоПодсистем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
		
		Если Пакет.Отказ = Истина Тогда
			ПерейтиНаСтраницу1();
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Пакет.ЗакрытьПослеЗаписи = Истина Тогда
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы(, ИмяФормы);
		Закрыть(Новый ВыборНастроек(ВариантКлючВарианта));
		Пакет.ЗакрытьПослеЗаписи = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницу1()
	Элементы.Страницы.ТекущаяСтраница = Элементы.Страница1;
	Элементы.Назад.Доступность        = Ложь;
	Элементы.Далее.Заголовок          = "";
	Элементы.Далее.Доступность        = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВариантДляИзменения()
	Вариант = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	Если Не ПравоНастройкиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
		ТекстПредупреждения = НСтр("ru = 'Недостаточно прав доступа для изменения варианта ""%1"".'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Вариант.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть()
	Страница2Заполнена = (Элементы.Страницы.ТекущаяСтраница = Элементы.Страница2);
	
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",       Не Страница2Заполнена);
	Пакет.Вставить("ПерейтиНаСтраницу2",       Не Страница2Заполнена);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Не Страница2Заполнена);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Истина);
	Пакет.Вставить("ЗакрытьПослеЗаписи",       Истина);
	Пакет.Вставить("ТекущийШаг", Неопределено);
	
	ВыполнитьПакет(Неопределено, Пакет);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбораЗавершение(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	ВариантОписание = ВведенныйТекст;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент и сервер

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
		
	БудетЗаписанНовый = Ложь;
	БудетПерезаписанСуществующий = Ложь;
	ПерезаписьНевозможна = Ложь;
	
	Идентификатор = Форма.Элементы.ВариантыОтчета.ТекущаяСтрока;
	Вариант = ?(Идентификатор <> Неопределено, Форма.ВариантыОтчета.НайтиПоИдентификатору(Идентификатор), Неопределено);
	
	Если Вариант = Неопределено Тогда
		БудетЗаписанНовый = Истина;
		Форма.ВариантСсылка = Неопределено;
		Форма.ВариантВидимостьПоУмолчанию = Истина;
		Если Не Форма.ОписаниеМодифицировано Тогда
			Форма.ВариантОписание = "";
		КонецЕсли;
		Форма.Элементы.ВариантыОтчета.ТекущаяСтрока = Неопределено;
		Если Не Форма.Контекст.ПолныеПраваНаВарианты Тогда
			Форма.ВариантТолькоДляАвтора = Истина;
		КонецЕсли;
	Иначе
		ПравоЗаписиВарианта = ПравоЗаписиВарианта(Вариант, Форма.Контекст.ПолныеПраваНаВарианты);
		Если ПравоЗаписиВарианта Тогда
			БудетПерезаписанСуществующий = Истина;
			Форма.НаименованиеМодифицировано = Ложь;
			Форма.ВариантНаименование = Вариант.Наименование;
			
			Форма.ВариантСсылка = Вариант.Ссылка;
			Если Форма.Контекст.ПолныеПраваНаВарианты Тогда
				Форма.ВариантТолькоДляАвтора = Вариант.ТолькоДляАвтора;
			Иначе	
				Форма.ВариантТолькоДляАвтора = Истина;
			КонецЕсли;
			Форма.ВариантВидимостьПоУмолчанию = Вариант.ВидимостьПоУмолчанию;
			Если Не Форма.ОписаниеМодифицировано Тогда
				Форма.ВариантОписание = Вариант.Описание;
			КонецЕсли;
		Иначе
			Если Форма.НаименованиеМодифицировано Тогда
				ПерезаписьНевозможна = Истина;
				Форма.Элементы.ВариантыОтчета.ТекущаяСтрока = Неопределено;
			Иначе
				БудетЗаписанНовый = Истина;
				Форма.ВариантНаименование = СформироватьСвободноеНаименование(Вариант, Форма.ВариантыОтчета);
			КонецЕсли;
			
			Форма.ВариантСсылка = Неопределено;
			Форма.ВариантТолькоДляАвтора      = Истина;
			Форма.ВариантВидимостьПоУмолчанию = Истина;
			Если Не Форма.ОписаниеМодифицировано Тогда
				Форма.ВариантОписание = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Форма.Доступен = ?(Форма.ВариантТолькоДляАвтора, "ТолькоАвтор", "ВсеПользователи");
	Если БудетЗаписанНовый Тогда
		Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница = Форма.Элементы.Новый;
		Форма.Элементы.СброситьНастройки.Видимость = Ложь;
		Форма.Элементы.Далее.Доступность     = Истина;
		Форма.Элементы.Сохранить.Доступность = Истина;
	ИначеЕсли БудетПерезаписанСуществующий Тогда
		Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница = Форма.Элементы.Перезапись;
		Форма.Элементы.СброситьНастройки.Видимость = Истина;
		Форма.Элементы.Далее.Доступность     = Истина;
		Форма.Элементы.Сохранить.Доступность = Истина;
	ИначеЕсли ПерезаписьНевозможна Тогда
		Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница = Форма.Элементы.ПерезаписьНевозможна;
		Форма.Элементы.СброситьНастройки.Видимость = Ложь;
		Форма.Элементы.Далее.Доступность     = Ложь;
		Форма.Элементы.Сохранить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат (ПолныеПраваНаВарианты Или Вариант.АвторТекущийПользователь) И ЗначениеЗаполнено(Вариант.Ссылка);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПравоЗаписиВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат Вариант.Пользовательский И ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьСвободноеНаименование(Вариант, ВариантыОтчета)
	ШаблонИмениВарианта = СокрЛП(Вариант.Наименование) +" - "+ НСтр("ru = 'копия'");
	
	СвободноеНаименование = ШаблонИмениВарианта;
	Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
	Если Найденные.Количество() = 0 Тогда
		Возврат СвободноеНаименование;
	КонецЕсли;
	
	НомерВарианта = 1;
	Пока Истина Цикл
		НомерВарианта = НомерВарианта + 1;
		СвободноеНаименование = ШаблонИмениВарианта +" (" + Формат(НомерВарианта, "") + ")";
		Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
		Если Найденные.Количество() = 0 Тогда
			Возврат СвободноеНаименование;
		КонецЕсли;
	КонецЦикла;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ВыполнитьПакетСервер(Пакет)
	
	Пакет.Вставить("Отказ", Ложь);
	
	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина Тогда
		Если Не Контекст.ЭтоВнешний Тогда
			ПерезаполнитьВторуюСтраницу(Пакет);
		КонецЕсли;
		Пакет.ЗаполнитьСтраницу2Сервер = Ложь;
	КонецЕсли;
	
	Если Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		ПроверитьИЗаписатьНаСервере(Пакет);
		Пакет.ПроверитьИЗаписатьСервер = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВариантНаСервере(Идентификатор)
	Если Идентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Вариант = ВариантыОтчета.НайтиПоИдентификатору(Идентификатор);
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПометкаУдаления = Не Вариант.ПометкаУдаления;
	ВариантОбъект = Вариант.Ссылка.ПолучитьОбъект();
	ВариантОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	Вариант.ПометкаУдаления = ПометкаУдаления;
	Вариант.ИндексКартинки  = ?(ПометкаУдаления, 4, ?(ВариантОбъект.Пользовательский, 3, 5));
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьВторуюСтраницу(Пакет)
	Если Пакет.ВариантЭтоНовый Тогда
		ВариантОснование = ПрототипСсылка;
	Иначе
		ВариантОснование = ВариантСсылка;
	КонецЕсли;
	
	ДеревоПриемник = ВариантыОтчетов.ДеревоПодсистемСформировать(ЭтотОбъект, ВариантОснование);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры

&НаСервере
Процедура ПроверитьИЗаписатьНаСервере(Пакет)
	ЭтоНовыйВариантОтчета = Не ЗначениеЗаполнено(ВариантСсылка);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Если Не ЭтоНовыйВариантОтчета Тогда
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантСсылка);
		КонецЕсли;
		Блокировка.Заблокировать();
		
		Если ЭтоНовыйВариантОтчета И ВариантыОтчетов.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, ВариантНаименование) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" занято, необходимо указать другое наименование.'"), ВариантНаименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ВариантНаименование");
			Пакет.Отказ = Истина;
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Если ЭтоНовыйВариантОтчета Тогда
			ВариантОбъект = Справочники.ВариантыОтчетов.СоздатьЭлемент();
			ВариантОбъект.Отчет            = Контекст.ОтчетСсылка;
			ВариантОбъект.ТипОтчета        = Контекст.ТипОтчета;
			ВариантОбъект.КлючВарианта     = Строка(Новый УникальныйИдентификатор());
			ВариантОбъект.Пользовательский = Истина;
			ВариантОбъект.Автор            = Контекст.ТекущийПользователь;
			Если ПрототипПредопределенный Тогда
				ВариантОбъект.Родитель = ПрототипСсылка;
			ИначеЕсли ТипЗнч(ПрототипСсылка) = Тип("СправочникСсылка.ВариантыОтчетов") И Не ПрототипСсылка.Пустая() Тогда
				ВариантОбъект.Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрототипСсылка, "Родитель");
			Иначе
				ВариантОбъект.ЗаполнитьРодителя();
			КонецЕсли;
		Иначе
			ВариантОбъект = ВариантСсылка.ПолучитьОбъект();
		КонецЕсли;
		
		Если Контекст.ЭтоВнешний Тогда
			ВариантОбъект.Размещение.Очистить();
		Иначе
			ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
			Если ЭтоНовыйВариантОтчета Тогда
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
			Иначе
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
			КонецЕсли;
			ВариантыОтчетов.ДеревоПодсистемЗаписать(ВариантОбъект, ИзмененныеРазделы);
		КонецЕсли;
		
		ВариантОбъект.Наименование = ВариантНаименование;
		ВариантОбъект.Описание     = ВариантОписание;
		ВариантОбъект.ТолькоДляАвтора      = ВариантТолькоДляАвтора;
		ВариантОбъект.ВидимостьПоУмолчанию = ВариантВидимостьПоУмолчанию;
		
		ВариантОбъект.Записать();
		
		ВариантСсылка       = ВариантОбъект.Ссылка;
		ВариантКлючВарианта = ВариантОбъект.КлючВарианта;
		
		Если СброситьНастройки Тогда
			ВариантыОтчетов.СброситьПользовательскиеНастройки(ВариантОбъект.Ссылка);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ЗаполнитьСписокВариантов(ОбновитьФорму)
	
	ТекущийКлючВарианта = ПрототипКлюч;
	
	// Подмена на ключ варианта "до перезаполнения".
	ИдентификаторТекущейСтроки = Элементы.ВариантыОтчета.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = ВариантыОтчета.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущийКлючВарианта = ТекущаяСтрока.КлючВарианта;
		КонецЕсли;
	КонецЕсли;
	
	ВариантыОтчета.Очистить();
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка КАК Ссылка,
	|	ВариантыОтчетов.Пользовательский КАК Пользовательский,
	|	ВариантыОтчетов.Наименование КАК Наименование,
	|	ВариантыОтчетов.Автор КАК Автор,
	|	ВариантыОтчетов.Описание КАК Описание,
	|	ВариантыОтчетов.ТипОтчета КАК Тип,
	|	ВариантыОтчетов.КлючВарианта КАК КлючВарианта,
	|	ВариантыОтчетов.ТолькоДляАвтора КАК ТолькоДляАвтора,
	|	ВариантыОтчетов.ВидимостьПоУмолчанию КАК ВидимостьПоУмолчанию,
	|	ВариантыОтчетов.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА ВариантыОтчетов.Автор = &ТекущийПользователь
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК АвторТекущийПользователь,
	|	ВЫБОР
	|		КОГДА ВариантыОтчетов.ПометкаУдаления
	|			ТОГДА 4
	|		КОГДА ВариантыОтчетов.Пользовательский
	|			ТОГДА 3
	|		ИНАЧЕ 5
	|	КОНЕЦ КАК ИндексКартинки,
	|	ВЫБОР
	|		КОГДА ВариантыОтчетов.ПометкаУдаления
	|			ТОГДА 3
	|		КОГДА ВариантыОтчетов.Пользовательский
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет = &Отчет
	|	И (ВариантыОтчетов.ПометкаУдаления = ЛОЖЬ
	|		ИЛИ ВариантыОтчетов.Пользовательский = ИСТИНА)
	|	И (ВариантыОтчетов.ТолькоДляАвтора = ЛОЖЬ
	|		ИЛИ ВариантыОтчетов.Автор = &ТекущийПользователь
	|		ИЛИ ВариантыОтчетов.КлючВарианта = &ПрототипКлюч
	|		ИЛИ ВариантыОтчетов.КлючВарианта = &ТекущийКлючВарианта)
	|	И НЕ ВариантыОтчетов.ПредопределенныйВариант В (&ОтключенныеВариантыПрограммы)";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отчет", Контекст.ОтчетСсылка);
	Запрос.УстановитьПараметр("ПрототипКлюч", ПрототипКлюч);
	Запрос.УстановитьПараметр("ТекущийКлючВарианта", ТекущийКлючВарианта);
	Запрос.УстановитьПараметр("ТекущийПользователь", Контекст.ТекущийПользователь);
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы", ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы());
	
	Запрос.Текст = ТекстЗапроса;
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	
	ВариантыОтчета.Загрузить(ТаблицаЗначений);
	
	// Добавить предопределенные варианты внешнего отчета.
	Если Контекст.ЭтоВнешний Тогда
		Попытка
			ОтчетОбъект = ВнешниеОтчеты.Создать(Контекст.ОтчетИмя);
		Исключение
			ВариантыОтчетов.ЗаписатьВЖурнал(УровеньЖурналаРегистрации.Ошибка,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось получить список предопределенных вариантов
						|внешнего отчета ""%1"":'"),
					Контекст.ОтчетСсылка)
				+ Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		Если ОтчетОбъект.СхемаКомпоновкиДанных = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ВариантНастроекКД Из ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек Цикл
			Вариант = ВариантыОтчета.Добавить();
			Вариант.Пользовательский = Ложь;
			Вариант.Наименование = ВариантНастроекКД.Представление;
			Вариант.КлючВарианта = ВариантНастроекКД.Имя;
			Вариант.ТолькоДляАвтора = Ложь;
			Вариант.АвторТекущийПользователь = Ложь;
			Вариант.ИндексКартинки = 5;
		КонецЦикла;
	КонецЕсли;
	
	ВариантыОтчета.Сортировать("Наименование Возр");
	
	Контекст.ПоискПоНаименованию = Новый Соответствие;
	Для Каждого Вариант Из ВариантыОтчета Цикл
		Идентификатор = Вариант.ПолучитьИдентификатор();
		Контекст.ПоискПоНаименованию.Вставить(Вариант.Наименование, Идентификатор);
		Если Вариант.КлючВарианта = ПрототипКлюч Тогда
			ПрототипСсылка           = Вариант.Ссылка;
			ПрототипПредопределенный = Не Вариант.Пользовательский;
		КонецЕсли;
		Если Вариант.КлючВарианта = ТекущийКлючВарианта Тогда
			Элементы.ВариантыОтчета.ТекущаяСтрока = Идентификатор;
		КонецЕсли;
	КонецЦикла;
	
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УдалитьВторуюСтрокуВЗаголовке(ТекстЗаголовка)
	ТекстЗаголовка = Лев(ТекстЗаголовка, СтрНайти(ТекстЗаголовка, Символы.ПС)-1);
КонецПроцедуры

#КонецОбласти
