перем  мОстанавливатьПриходПриОшибке экспорт;


#Область Обмен
Функция   	ВыгрузитьНаСайт() Экспорт
	СтоСПОбмен_Посылки_income.ВыгрузитьПоступления_income(ЭтотОбъект);
КонецФункции

#КонецОбласти



#Область Проведение

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);  
	
	
	///Данные Заказов
	ДанныеЗаказовДоПроведения = СинхронизацияПоступлений.ПолучитьДанныеЗаказов(Ссылка);
	
	СП_ДвиженияСервер.ОтразитьДвиженияДанныеЗаказов(Движения.ДанныеЗаказов, Ссылка);
	
	ДанныеЗаказовПослеПроведения = Движения.ДанныеЗаказов.Выгрузить();
	СинхронизацияПоступлений.СкорректироватьПоступления(ДанныеЗаказовДоПроведения,ДанныеЗаказовПослеПроведения, Отказ);
	
	Если отказ тогда Возврат; КонецЕсли;
	///Данные Заказов
	
	#Область ПравильноеПроведение
	Документы.Приходная.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("НеВыгруженноНаСайт",	ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Приход",				ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ШтрафныеЗаказы",		ДополнительныеСвойства, Движения, Отказ);
//	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ДанныеЗаказов",		ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ОборотнаяТараДвижение",ДополнительныеСвойства, Движения, Отказ);
	
	СтараяМетодика = (не СинхронизацияПоступлений.НоваяМетодика(Дата));
	Если СтараяМетодика Тогда
		СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Транзит",					ДополнительныеСвойства, Движения, Отказ);
		СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ОстаткиТоваров",			ДополнительныеСвойства, Движения, Отказ);
		СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ЗаказыВПосылках",			ДополнительныеСвойства, Движения, Отказ);
		СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Обмен100СПрн_Ошибки",	   ДополнительныеСвойства, Движения, Отказ);
		СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ДанныеЗаказовСайт",		ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;	
	#КонецОбласти
	

//	ДвигаемНегабаритЗначения();
//	ДвигаемПокупкиОтдельнымМестом(Отказ, РежимПроведения);
	//Если Транзит Тогда

	//	ДвиженияСтатусыДоставки(Отказ, РежимПроведения);
	//	ДвиженияСтатусыДоставкиСвернуто(Отказ, РежимПроведения);

	//КонецЕсли;
	
	//Если не отказ тогда
	//	ДанныеЗаказовПослеПроведения = Движения.ДанныеЗаказов.Выгрузить();
	//	СинхронизацияПоступлений.СкорректироватьПоступления(ДанныеЗаказовДоПроведения,ДанныеЗаказовПослеПроведения);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ДвиженияСтатусыДоставки(Отказ, Режим)
	
	
	Движения.СтатусыДоставки.Записывать = Истина;
	Для каждого стр из Покупки Цикл 
		Если ТипЗнч(Стр.Покупка)<> Тип("СправочникСсылка.Коробки") Тогда Возврат КонецЕсли;
		Движение = Движения.СтатусыДоставки.Добавить();
		Движение.Период = Дата;
		Движение.Груз = Стр.Покупка;
		Движение.Статус = Перечисления.СтатусыОтправкиГруза.НаСкладе;
	КонецЦикла;
КонецПроцедуры

Процедура ДвиженияСтатусыДоставкиСвернуто(Отказ, Режим)
	Движения.СтатусыДоставкиСвернуто.Записывать = Истина;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	    "ВЫБРАТЬ
	 |	ЗНАЧЕНИЕ(Документ.ЗаявкаВТранспортнуюКомпанию.ПустаяСсылка) КАК ЗаявкаВТК,
	 |	СУММА(1) КАК КоличествоГС,
	 |	СУММА(ПриходнаяПокупки.Покупка.Количество) КАК Количество,
	 |	ПриходнаяПокупки.Ссылка.Дата КАК Период,
	 |	ЗНАЧЕНИЕ(Перечисление.СтатусыОтправкиГруза.НаСкладе) КАК Статус,
	 |	СУММА(0) КАК КоличествоМест
	 |ИЗ
	 |	Документ.Приходная.Покупки КАК ПриходнаяПокупки
	 |ГДЕ
	 |	ПриходнаяПокупки.Ссылка = &Ссылка
	 |	И ТИПЗНАЧЕНИЯ(ПриходнаяПокупки.Покупка) = ТИП(Справочник.Коробки)
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	ПриходнаяПокупки.Ссылка.Дата";
	Запрос.Параметры.Вставить("Ссылка",Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Движения.СтатусыДоставкиСвернуто.Загрузить(РезультатЗапроса.Выгрузить());

	
КонецПроцедуры

#КонецОбласти


#Область СобытияОбъекта

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Константы.ПроверятьОтветственногоПриРасходе.Получить() Тогда
		ПроверяемыеРеквизиты.Добавить("Ответственный");	
	КонецЕсли;	
	Если Транзит Тогда
		НеПроверять	= "Организатор";
	Иначе
	    НеПроверять	= "ТочкаНазначения";
	КонецЕсли;	
	инд=ПроверяемыеРеквизиты.Найти(НеПроверять);
	Если инд<>Неопределено Тогда ПроверяемыеРеквизиты.Удалить(инд); КонецЕсли;
	
	НеПроверятьОрга=Истина;
	Для каждого стр из Покупки Цикл
		Если ТипЗнч(стр.Покупка)=Тип("СправочникСсылка.Покупки") Тогда
			НеПроверятьОрга=Ложь;
		КонецЕсли;	
	КонецЦикла;
	Если НеПроверятьОрга Тогда
		инд=ПроверяемыеРеквизиты.Найти("Организатор");
		Если инд<>Неопределено Тогда ПроверяемыеРеквизиты.Удалить(инд); КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	мОстанавливатьПриходПриОшибке=Константы.ОстанавливатьПриходПриОшибке.Получить();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если не ЗначениеЗаполнено(СвояТочка) Тогда
		СвояТочка=Константы.СвояТочка.Получить();
	Конецесли;	
	Если Транзит Тогда
		Точка=ПунктВыдачи;
	Иначе
		Точка=СвояТочка;
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Точка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( "Не выбрана точка раздачи!");
		Возврат;
	КонецЕсли;
	
	Ошибки=Неопределено;

	Для каждого стр из Покупки Цикл
		Если не Транзит и ТипЗнч(стр.Покупка)=Тип("СправочникСсылка.Коробки")  Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,"Объект.Покупки[%1].Покупка","Нельзя поставить на приход коробку.Нужно либо поставить на транзит, либо Разобрать коробку.",,стр.НомерСтроки,,стр.НомерСтроки-1);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(стр.ШК) Тогда Продолжить; КонецЕсли;
		стр.ШК	= СП_Штрихкоды.ПолучитьМегаордер(стр.Покупка,стр.Участник,Точка);
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки,отказ);
	
	массПосылки = Посылки.НайтиСтроки(новый Структура("Посылка",Справочники.Посылки.ПустаяСсылка()));
	Для каждого пос из массПосылки Цикл
		Посылки.Удалить(пос);
	КонецЦикла;	
	
	НеОтправленныеПосылки = Посылки.НайтиСтроки(новый Структура("Отправлено",Ложь));
	Если НеОтправленныеПосылки.Количество()>0 Тогда
		Отправлено = Ложь;
	КонецЕсли;	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ДанныеЗаказовДоПроведения = СинхронизацияПоступлений.ПолучитьДанныеЗаказов(Ссылка);
	ДанныеЗаказовПослеПроведения = ДанныеЗаказовДоПроведения.СкопироватьКолонки();
	СинхронизацияПоступлений.СкорректироватьПоступления(ДанныеЗаказовДоПроведения,ДанныеЗаказовПослеПроведения, Отказ);
КонецПроцедуры

#КонецОбласти


#Область НеИспоьзуется        



//Процедура ДвигаемПокупкиОтдельнымМестом(Отказ, Режим)
//	Движения.ПокупкиОтдельнымМестом.Записывать = Истина;
//		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
//	// Данный фрагмент построен конструктором.
//	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ПриходнаяПокупки.Ссылка.Дата КАК Период,
//		|	ПриходнаяПокупки.Покупка,
//		|	ПриходнаяПокупки.Участник,
//		|	МАКСИМУМ(ПриходнаяПокупки.ОтдельнымМестом) КАК ОтдельнымМестом
//		|ИЗ
//		|	Документ.Приходная.Покупки КАК ПриходнаяПокупки
//		|ГДЕ
//		|	ПриходнаяПокупки.Ссылка = &Ссылка
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	ПриходнаяПокупки.Участник,
//		|	ПриходнаяПокупки.Покупка,
//		|	ПриходнаяПокупки.Ссылка.Дата";
//	Запрос.Параметры.Вставить("Ссылка",Ссылка);
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	Движения.ПокупкиОтдельнымМестом.Загрузить(РезультатЗапроса.Выгрузить());
//	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

//	//Для Каждого ТекСтрокаПокупки Из Покупки Цикл
//	//	Движение = Движения.ПокупкиОтдельнымМестом.Добавить();
//	//	Движение.Участник = ТекСтрокаПокупки.Участник;
//	//	Движение.Покупка = ТекСтрокаПокупки.Покупка;
//	//	Движение.ОтдельнымМестом = ТекСтрокаПокупки.ОтдельнымМестом;
//	//КонецЦикла;
//КонецПроцедуры



//Процедура ДвигаемНегабаритЗначения()
//	Движения.НегабаритЗначения.Записывать = Истина;
//	Для Каждого ТекСтрокаПокупки Из Покупки Цикл
//		Если ТекСтрокаПокупки.Вес>0 или ТекСтрокаПокупки.объем>0 Тогда
//			Движение = Движения.НегабаритЗначения.Добавить();
//			Движение.Покупка = ТекСтрокаПокупки.Покупка;
//			Движение.Участник = ТекСтрокаПокупки.Участник;
//			Движение.Габарит = ТекСтрокаПокупки.Габарит;
//			Движение.Вес = ТекСтрокаПокупки.Вес;
//			Движение.объем = ТекСтрокаПокупки.объем;
//			Движение.Партия=Ссылка;
//		КонецЕсли;
//	КонецЦикла;
//	Для Каждого ТекСтрокаПокупки Из Посылки Цикл
//		Если ТекСтрокаПокупки.Вес>0 или ТекСтрокаПокупки.объем>0 Тогда
//			Движение = Движения.НегабаритЗначения.Добавить();
//			Движение.Покупка = ТекСтрокаПокупки.Посылка;
//			Движение.Участник = ТекСтрокаПокупки.Посылка.Участник;
//			Движение.Габарит = ТекСтрокаПокупки.Габарит;
//			Движение.Вес = ТекСтрокаПокупки.Вес;
//			Движение.объем = ТекСтрокаПокупки.объем;
//			Движение.Партия=Ссылка;
//		КонецЕсли;
//	КонецЦикла;	
//КонецПроцедуры

#КонецОбласти