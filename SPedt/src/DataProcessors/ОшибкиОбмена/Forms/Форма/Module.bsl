
Функция ПараметрыПоОшибке(СтрокаОшибки,тз)
	
	параметрыОшибки = Новый Структура("имяТаблицы, ЗаголовокТаблицы , Таблица,  Колонки, Команды, События, ОписаниеОшибки");
	параметрыОшибки.Таблица = тз;	
	КомандыОбработки  = новый Структура;
	СобытияТаблицы    = новый Структура;
	Колоноки = новый Структура;
	КомандыОбработки.Вставить("ЗакрытьОшибки",					"Закрыть ошибки");
	Если СтрокаОшибки.СообщениеОшибки = "Изменился пункт назначения посылки!" или
		 СтрокаОшибки.СообщениеОшибки = "Изменился пункт выдачи" 			Тогда
		КомандыОбработки.Вставить("ОставитьПВШК",					"Оставить пункт выдачи со стикера");
		КомандыОбработки.Вставить("УстановитьНовыйПВ",				"Установить новый пункт выдачи");
		КомандыОбработки.Вставить("перепровестиДокументыСОшибками",	"перепровести выделеные документы");
		
		Колоноки.Вставить("Покупка","Покупка");
		Колоноки.Вставить("Участник","Участник");
		Колоноки.Вставить("Документ","Документ");
		Колоноки.Вставить("ПунктВыдачиНаСтикере","Пункт выдачи (на стикере)");
		Колоноки.Вставить("ПунктВыдачиНовый","Пункт выдачи (новый)");
		
		параметрыОшибки.ОписаниеОшибки = 
		"После печати штрих кода у заказа изменили пуннкт назначения. 
		|В результате пункт выдачи на стикере отличается от актуального пункта выдачи заказа";
	ИначеЕсли СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.ЗагрузкаСправочников Тогда
		КомандыОбработки.Вставить("ВыполнитьОбмен",					"Выполнить обмен");
		
		Колоноки.Вставить("Документ","Документ");
		
		параметрыОшибки.ОписаниеОшибки = 
		"Ошибки при получении справочников. 
		|вероятно из за проблем с интернетом";

		
 	ИначеЕсли 	СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.Приход или
				СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.ЗагрузкаПосылок  или
				СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.ПередачаВозврата  или
				СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.Возврат         Тогда
		//КомандыОбработки.Вставить("ОставитьПВШК",					"Оставить пункт выдачи со стикера");
		КомандыОбработки.Вставить("ВыполнитьОбмен",					"Выполнить обмен");
		КомандыОбработки.Вставить("перепровестиДокументыСОшибками",	"перепровести выделеные документы");
		
		Колоноки.Вставить("Покупка",			"Покупка");
		Колоноки.Вставить("Участник",			"Участник");
		Колоноки.Вставить("Документ",			"Документ");
		Колоноки.Вставить("Партия",			"Партия");
		Колоноки.Вставить("ОписаниеОшибки",		"Описание ошибки");
		
		
		параметрыОшибки.ОписаниеОшибки = 
		"Либо не было выгрузки на сайт,  
		|Либа в результате выгрузки произошла ошибка.";
	ИначеЕсли 	СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.ГруппыДоставкиЗапросОплаты или
				СтрокаОшибки.типОбмена = Перечисления.ТипыОбменов100сп.ГруппыДоставкиЗапросОтсрочки         Тогда
		//КомандыОбработки.Вставить("ОставитьПВШК",					"Оставить пункт выдачи со стикера");
		КомандыОбработки.Вставить("ПросмотрСтатусаГруппы",			"Статус группы");
		КомандыОбработки.Вставить("ПросмотрСтатусаЗаказовГруппы",	"Статус заказов группы");
		КомандыОбработки.Вставить("ПросмотрИсторииОбменовГруппы",	"История обменов группы");
		
		Колоноки.Вставить("Покупка",			"Покупка");
		Колоноки.Вставить("Участник",			"Участник");
		Колоноки.Вставить("Документ",			"Документ");
		Колоноки.Вставить("Партия",			"Партия");
	//	Колоноки.Вставить("ОписаниеОшибки",		"Описание ошибки");
		
		
		параметрыОшибки.ОписаниеОшибки = ""; 
		
		
		
	Иначе
		//КомандыОбработки.Вставить("УстановитьНовыйПВ","Установить новый пункт выдачи");
		
		Колоноки.Вставить("Покупка","Покупка");
		Колоноки.Вставить("Участник","Участник");
		Колоноки.Вставить("Документ","Документ");
		Колоноки.Вставить("ПунктВыдачиНаСтикере","Пункт выдачи (на стикере)");
		Колоноки.Вставить("ПунктВыдачиНовый","Пункт выдачи (новый)");
		параметрыОшибки.ОписаниеОшибки = "";
	КонецЕсли;		

		
	СобытияТаблицы.Вставить("Выбор", "РасшифровкаОшибокВыбор");
	
	параметрыОшибки.имяТаблицы 			= "ОшибкиРасшифровка";	
	параметрыОшибки.ЗаголовокТаблицы  	= СтрокаОшибки.СообщениеОшибки;	
	параметрыОшибки.колонки 			= Колоноки;
	параметрыОшибки.команды 			= КомандыОбработки;
	параметрыОшибки.События 			= СобытияТаблицы;
	возврат параметрыОшибки;
	
КонецФункции	



&НаКлиенте
Процедура СводОшибокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьОшибки(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибки(Команда)
		Если Элементы.СводОшибок.ТекущиеДанные <> Неопределено Тогда
	
		СтрокаОшибки = Элементы.СводОшибок.ТекущиеДанные;
		//Ошибки.Параметры.УстановитьЗначениеПараметра("СообщениеОшибки",Ошибка);
		ЗаполнитьТаблицуОшибки(СтрокаОшибки);		
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьТаблицуОшибки(СтрокаОшибки)
	
	Если СтрокаОшибки.Свойство("СообщениеОшибки") Тогда
		тзОшибок = СП_Отчеты.ТаблицаОшибкиОбмена("Детальный",СтрокаОшибки);
		Элементы.ГруппаОшибкиРасшифровка.Видимость = (тзОшибок.Количество()>0);
		
		параметрыОшибки = ПараметрыПоОшибке(СтрокаОшибки, тзОшибок);
		Элементы.ОписаниеОшибок.Заголовок =  параметрыОшибки.ОписаниеОшибки;
		
		элементТаблицы = сп_Интерфейс.СоздатьТаблицуОтчета(параметрыОшибки,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры




#Область КомандыИсправленияОшибок
&НаКлиенте
Процедура УстановитьНовыйПВ(Команда)
	УстановитьПВНаСервере(ложь);
	ОбновитьСписки();
КонецПроцедуры

&НаКлиенте
Процедура ОставитьПВШК(Команда)
	УстановитьПВНаСервере(Истина);
	ОбновитьСписки();
КонецПроцедуры

Процедура УстановитьПВНаСервере(ОтавитьССтарый = Истина)
	Для каждого элем из Элементы.ТаблицаОшибкиРасшифровка.ВыделенныеСтроки Цикл
		выделеннаяСтрока = ЭтаФорма["ТаблицаОшибкиРасшифровка"].НайтиПоИдентификатору(элем);
		док = выделеннаяСтрока.Документ.ПолучитьОбъект();
		ЭтоСинхронизация = (ТипЗнч(док) = Тип("ДокументОбъект.СинхронизацияПоступлений"));
		Если ОтавитьССтарый Тогда
			ПунктВыдачи = выделеннаяСтрока.ПунктВыдачиНаСтикере;
		Иначе
			ПунктВыдачи = выделеннаяСтрока.ПунктВыдачиНовый;
		КонецЕсли;
		
		Если не ЗначениеЗаполнено(ПунктВыдачи) Тогда Продолжить; КонецЕсли;
		
		Если ЭтоСинхронизация Тогда
			массСтрок = док.Данные.НайтиСтроки(новый Структура("Заказ, Партия",выделеннаяСтрока.Покупка, выделеннаяСтрока.Партия));
			Если массСтрок.Количество()>0 Тогда
				массСтрок[0].ПунктВыдачи = ПунктВыдачи;
				массСтрок[0].ПунктВыдачиНаСтикере = ПунктВыдачи;
		    КонецЕсли;
		КонецЕсли;
		///////////////
		Если ОтавитьССтарый Тогда
			пос = выделеннаяСтрока.Покупка.ПолучитьОбъект();
			пос.ПунктВыдачи = ПунктВыдачи;
			Попытка
			   	пос.Записать();
			Исключение
			КонецПопытки;
		ИначеЕсли не ЭтоСинхронизация Тогда
			строкаДокумента = док.Посылки[выделеннаяСтрока.СтрокаВПартии - 1];
			строкаДокумента.ПунктВыдачи = ПунктВыдачи;
		КонецЕсли;
		
		Попытка
			док.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			
		КонецПопытки;

	КонецЦикла;
КонецПроцедуры

///////////////////////////////////////////////////
&НаКлиенте
Процедура перепровестиДокументыСОшибками(Команда)
	перепровестиДокументыСОшибкамиНаСервере();
	ОбновитьСписки();
КонецПроцедуры

Процедура перепровестиДокументыСОшибкамиНаСервере()
	обработано = новый Массив;
	Для каждого элем из Элементы.ТаблицаОшибкиРасшифровка.ВыделенныеСтроки Цикл
		выделеннаяСтрока = ЭтаФорма["ТаблицаОшибкиРасшифровка"].НайтиПоИдентификатору(элем);

		///////////////
		док = выделеннаяСтрока.Документ.ПолучитьОбъект();
		если обработано.Найти(док) = неопределено Тогда
			Попытка
				док.Записать(РежимЗаписиДокумента.Проведение);
				
			Исключение
				
			КонецПопытки;
			
			обработано.Добавить(док);
		КонецЕсли
		//////////////////
		
	КонецЦикла;

КонецПроцедуры

/////////////////////////////////////////////////////

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	ВыполнитьОбменНаСервере();
	ОбновитьСписки();
КонецПроцедуры

Процедура ВыполнитьОбменНаСервере()
	обрабоанныеДокументы = Новый Массив;
	Для каждого элем из Элементы.ТаблицаОшибкиРасшифровка.ВыделенныеСтроки Цикл
		выделеннаяСтрока = ЭтаФорма["ТаблицаОшибкиРасшифровка"].НайтиПоИдентификатору(элем);
		документ = выделеннаяСтрока.Документ;
		Если обрабоанныеДокументы.Найти(документ) <> Неопределено Тогда
		    Продолжить;
		Иначе
			обрабоанныеДокументы.Добавить(Документ);
		КонецЕсли;
		
		докОб = документ.ПолучитьОбъект();
		Если ТипЗнч(документ) = Тип("ДокументСсылка.РазборКоробки") или
			 ТипЗнч(документ) = Тип("ДокументСсылка.Приходная")     или
			  ТипЗнч(документ) = Тип("ДокументСсылка.СинхронизацияПоступлений")     или
			 ТипЗнч(документ) = Тип("ДокументСсылка.Выгрузка_100СП")     Тогда

			докОб.Заблокировать();
			докОб.ВыгрузитьНаСайт();
			докОб.Заблокировать();
			Попытка
				докОб.Записать(РежимЗаписиДокумента.Проведение)
			Исключение
				ТекстОшибки = ОписаниеОшибки();
			КонецПопытки;
			
		ИначеЕсли ТипЗнч(документ) = Тип("ДокументСсылка.СинхронизацияСправочников") Тогда
			
			докОб.ЗаполнитьПеродыЗагрузки();
			докОб.Дата	= ТекущаяДата();
			докОб.ЗагрузитьСправочники();
			Попытка
				докОб.Записать(РежимЗаписиДокумента.Проведение)
			Исключение
				ТекстОшибки = ОписаниеОшибки();
			КонецПопытки;
		ИначеЕсли ТипЗнч(документ) = Тип("ДокументСсылка.Выгрузка_100СП") Тогда			
			
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры

//////////////////////////////////////////////////////

&НаКлиенте
Процедура ПросмотрСтатусаГруппы(Команда)
	ОповещениеОЗакрытии = новый ОписаниеОповещения("ОбновитьСписки",ЭтотОбъект);
	
	
	Группа            	= Элементы.ТаблицаОшибкиРасшифровка.ТекущиеДанные.Покупка;
	ДокументРезультат	= новый ТабличныйДокумент;
	данныеОтчета 		= СП_Отчеты.СтатусыГруппы(Группа,ДокументРезультат,УникальныйИдентификатор);

	ПараметрыФормыОшибок = Новый Структура;
	ПараметрыФормыОшибок.Вставить("Результат",			ДокументРезультат);
	ПараметрыФормыОшибок.Вставить("АдресРасшифровки",  	данныеОтчета.АдресРасшифровки);
	ПараметрыФормыОшибок.Вставить("АдресСКД", 			данныеОтчета.АдресХранилищаСКД);
	ПараметрыФормыОшибок.Вставить("Заголовок", "Статусы "+Группа);


	ОткрытьФорму("Общаяформа.ФормаПросмотраОшибок",ПараметрыФормыОшибок,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

	//ВыполнитьОбменНаСервере();
//	ОбновитьСписки();
КонецПроцедуры

//////////////////////////////////////////////////////

&НаКлиенте
Процедура ПросмотрСтатусаЗаказовГруппы(Команда)
	ОповещениеОЗакрытии = новый ОписаниеОповещения("ОбновитьСписки",ЭтотОбъект);
	
	
	Группа            	= Элементы.ТаблицаОшибкиРасшифровка.ТекущиеДанные.Покупка;
	ДокументРезультат	= новый ТабличныйДокумент;
	данныеОтчета 		= СП_Отчеты.СтатусЗаказовГруппы(Группа,ДокументРезультат,УникальныйИдентификатор);

	ПараметрыФормыОшибок = Новый Структура;
	ПараметрыФормыОшибок.Вставить("Результат",			ДокументРезультат);
	ПараметрыФормыОшибок.Вставить("АдресРасшифровки",  	данныеОтчета.АдресРасшифровки);
	ПараметрыФормыОшибок.Вставить("АдресСКД", 			данныеОтчета.АдресХранилищаСКД);
	ПараметрыФормыОшибок.Вставить("Заголовок", "Статусы "+Группа);


	ОткрытьФорму("Общаяформа.ФормаПросмотраОшибок",ПараметрыФормыОшибок,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

	//ВыполнитьОбменНаСервере();
//	ОбновитьСписки();
КонецПроцедуры

//////////////////////////////////////////////////////

&НаКлиенте
Процедура ПросмотрИсторииОбменовГруппы(Команда)
	ОповещениеОЗакрытии = новый ОписаниеОповещения("ОбновитьСписки",ЭтотОбъект);
	Группа            	= Элементы.ТаблицаОшибкиРасшифровка.ТекущиеДанные.Покупка;
	данныеОтчета 		= СП_Отчеты.ТаблицаГруппыДоставкиИстроияОбменов(Группа,УникальныйИдентификатор);

	ПараметрыФормыОшибок = Новый Структура;
	ПараметрыФормыОшибок.Вставить("Результат",			данныеОтчета.Результат);
	ПараметрыФормыОшибок.Вставить("АдресРасшифровки",  	данныеОтчета.ДанныеРасшифровки);
	ПараметрыФормыОшибок.Вставить("АдресСКД", 			данныеОтчета.СКД);
	ПараметрыФормыОшибок.Вставить("Заголовок", "Статусы "+Группа);

	ОткрытьФорму("Общаяформа.ФормаПросмотраОшибок",ПараметрыФормыОшибок,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

	//ВыполнитьОбменНаСервере();
//	ОбновитьСписки();
КонецПроцедуры

//////////////////////////////////////////////////////



&НаКлиенте
Процедура ЗакрытьОшибки(Команда)
	АдресВХ = ЗакрытьОшибкиНаСервере();
	ОповещениеОЗакрытии = новый ОписаниеОповещения("ОбновитьСписки",ЭтотОбъект);
	ОткрытьФорму("Документ.ЗакрытиеОшибокОбмена.Форма.ФормаДокумента",новый Структура("ДанныеЗаполнения",АдресВХ),ЭтаФорма,,,,ОповещениеОЗакрытии);
КонецПроцедуры

Функция ЗакрытьОшибкиНаСервере()
	СписокСтрок = Новый массив;
	Для каждого элем из Элементы.ТаблицаОшибкиРасшифровка.ВыделенныеСтроки Цикл
		выделеннаяСтрока = ЭтаФорма["ТаблицаОшибкиРасшифровка"].НайтиПоИдентификатору(элем);
		СписокСтрок.Добавить(выделеннаяСтрока);
	КонецЦикла;
	Возврат ПоместитьВоВременноеХранилище(СписокСтрок);
КонецФункции

	

///////////////////////////////////////////////////



&НаКлиенте
Процедура ОбновитьСписки(Резудльтат = Неопределено, ДопПараметры = Неопределено) Экспорт
	ПоказатьОшибки(Неопределено);
	Элементы.СводОшибок.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаОшибокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка 	= Ложь;
	ИмяТаблицы 				= Элемент.Имя	;
	ИмяПоля	   				= СтрЗаменить(Поле.Имя, ИмяТаблицы,"");
	ВыбранныйЭлемент =  ЭтаФорма[ИмяТаблицы].НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля];
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		ПоказатьЗначение(,ВыбранныйЭлемент);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаОшибкиРасшифровка.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчет(Команда)
	ОткрытьФорму("Отчет.ОшибкиОбмена100СП.Форма",,ЭтаФорма);
КонецПроцедуры



#КонецОбласти