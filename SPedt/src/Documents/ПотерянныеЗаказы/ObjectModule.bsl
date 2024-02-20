


#Область Обмен
Функция   	ВыгрузитьНаСайт() Экспорт
	СтоСПОбмен_ПотерянныеЗаказы_lostOrder.ВыгрузитьПотерянныеЗаказы_lostOrder(ЭтотОбъект);
КонецФункции

#КонецОбласти

	

Процедура ЗаполнитьПросроченнымиЗаказами() Экспорт
	строкиСКомментарием = Заказы.Выгрузить(новый Структура("Выгружать",Истина));
	
	
	тзОстаткипросроченых = ПолучитьОстаткиПросроченныхЗаказов();
	Заказы.Загрузить(тзОстаткипросроченых);
	
	ПробленыеЗаказы_НаДатуДокумента  = СП_Отчеты.ТаблицаПокупкиВПути(Дата);
	ПробленыеПосылки_ВДеньДокумента  = ПробленыеЗаказы_НаДатуДокумента.Скопировать(Новый Структура("ТипЗаказа", Тип("СправочникСсылка.Посылки")));
	ПробленыеКоробки_ВДеньДокумента  = ПробленыеЗаказы_НаДатуДокумента.Скопировать(Новый Структура("ТипЗаказа", Тип("СправочникСсылка.Коробки")));
	
	
	ЗаказыВКоробках = ПолучитьНедоехавшиеЗаказыВКоробках(ПробленыеКоробки_ВДеньДокумента);
	
	Для каждого элем из ПробленыеПосылки_ВДеньДокумента Цикл
		новаяСтрока = Заказы.Добавить();
	    ЗаполнитьЗначенияСвойств(новаяСтрока,элем);
	КонецЦикла;

	Для Каждого элем из ЗаказыВКоробках Цикл
		новаяСтрока = Заказы.Добавить();
	    ЗаполнитьЗначенияСвойств(новаяСтрока,элем);
	КонецЦикла;
	
	Для каждого элем из строкиСКомментарием Цикл
		масСтрок = Заказы.НайтиСтроки(новый Структура("номерНакладной, ДатаНакладной,ПунктВыдачи, Посылка",
														элем.номерНакладной, элем.ДатаНакладной, элем.ПунктВыдачи, элем.Посылка));
		ЗаполнитьЗначенияСвойств(масСтрок[0], элем);
	КонецЦикла;
	
	ОтметитьПринятыеЗаказы();
	 	
	ЗаполнитьНакладные();

КонецПроцедуры	

Процедура ОтметитьПринятыеЗаказы() экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваров.Покупка КАК Посылка,
		|	ОстаткиТоваров.Период КАК Период
		|ПОМЕСТИТЬ Сбор
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров КАК ОстаткиТоваров
		|ГДЕ
		|	ОстаткиТоваров.Покупка В(&СписокПосылок)
		|	И ОстаткиТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Транзит.ПокупкаСсылка,
		|	Транзит.Период
		|ИЗ
		|	РегистрНакопления.Транзит КАК Транзит
		|ГДЕ
		|	Транзит.ПокупкаСсылка В(&СписокПосылок)
		|	И Транзит.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сбор.Посылка КАК Посылка,
		|	МИНИМУМ(Сбор.Период) КАК ДатаПоступленияЗаказа
		|ИЗ
		|	Сбор КАК Сбор
		|
		|СГРУППИРОВАТЬ ПО
		|	Сбор.Посылка";
	
	Запрос.УстановитьПараметр("СписокПосылок", Заказы.ВыгрузитьКолонку("Посылка"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		масс_Найдено = Заказы.НайтиСтроки(новый Структура("Посылка",Выборка.Посылка));
		Для каждого элем из масс_Найдено Цикл
			элем.ПринятоСОпозданием 	= Истина;
			элем.ДатаПоступленияЗаказа 	= Выборка.ДатаПоступленияЗаказа;
			элем.Комментарий			= "Заказ поступил "+Выборка.ДатаПоступленияЗаказа;
			элем.ВопросРешен			= Истина;
			элем.ДатаКомментария		= ТекущаяДата();
		КонецЦикла;	
	КонецЦикла;
	


	
	
КонецПроцедуры	

Процедура 	ЗаполнитьНакладные()
	тзНакладные = Заказы.Выгрузить(,"НомерНакладной,ДатаНакладной, ПунктВыдачи");
	тзНакладные.Свернуть("НомерНакладной,ДатаНакладной, ПунктВыдачи",);
	Накладные.Загрузить(тзНакладные);
КонецПроцедуры	


Функция 	ПолучитьНеДоехавшиеЗаказыВКоробках(тзСГруппами)
	тзРезультат = тзСГруппами.скопироватьКолонки();
			
	
	СписокКоробок = тзСГруппами.выгрузитьКолонку("Коробка");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КоробкиСостав.Ссылка КАК Коробка,
		|	КоробкиСостав.Покупка КАК Покупка,
		|	КоробкиСостав.Участник КАК Участник,
		|	ЕСТЬNULL(Приход.Количество, 0) КАК ПриехалоШтук
		|ИЗ
		|	Справочник.Коробки.Состав КАК КоробкиСостав
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Приход КАК Приход
		|		ПО КоробкиСостав.Покупка = Приход.Покупка
		|			И КоробкиСостав.Участник = Приход.Участник
		|ГДЕ
		|	КоробкиСостав.Ссылка В(&СписокКоробок)
		|	И (КоробкиСостав.Ссылка.ТочкаНазначения = &СвояТочка
		|			ИЛИ КоробкиСостав.Ссылка.ТочкаНазначения = ЗНАЧЕНИЕ(Справочник.Коробки.ПустаяСсылка))";
	
	Запрос.УстановитьПараметр("СписокКоробок", 	СписокКоробок);
	Запрос.УстановитьПараметр("СвояТочка", 		Константы.СвояТочка.Получить());

	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.приехалоШтук=0 Тогда
			массСтрок = тзСГруппами.НайтиСтроки(Новый Структура("Коробка",Выборка.Коробка));
			новаяСтрока = тзРезультат.Добавить();
			ЗаполнитьЗначенияСвойств(новаяСтрока, массСтрок[0]);
			новаяСтрока.Посылка 	= Выборка.Покупка;
			новаяСтрока.Участник 	= Выборка.Участник;
		КонецЕсли	
	КонецЦикла;
	
    Возврат тзРезультат; 
КонецФункции	



Функция 	ПолучитьОстаткиПросроченныхЗаказов() 
	         
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК Остатки,
		|	ПотерянныеЗаказыОстатки.Посылка КАК Посылка,
		|	ПотерянныеЗаказыОстатки.Коробка КАК Коробка,
		|	ПотерянныеЗаказыОстатки.НомерНакладной КАК НомерНакладной,
		|	ПотерянныеЗаказыОстатки.ДатаНакладной КАК ДатаНакладной,
		|	ПотерянныеЗаказыОстатки.ПунктВыдачи КАК ПунктВыдачи,
		|	ПотерянныеЗаказыОстатки.КоличествоОстаток КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ПотерянныеЗаказы.Остатки(&ДатаДокумента, ) КАК ПотерянныеЗаказыОстатки
		|ГДЕ
		|	ПотерянныеЗаказыОстатки.КоличествоОстаток > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНакладной,
		|	НомерНакладной,
		|	Посылка";
	
	Запрос.УстановитьПараметр("ДатаДокумента", Дата-1);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Процедура 	ОбработкаПроведения(Отказ, РежимПроведения)
		
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПотерянныеЗаказы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ПотерянныеЗаказы", ДополнительныеСвойства, Движения, Отказ);
    СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("НеВыгруженноНаСайт", ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Обмен100СПрн_Ошибки", ДополнительныеСвойства, Движения, Отказ);
	
	#КонецОбласти

КонецПроцедуры
