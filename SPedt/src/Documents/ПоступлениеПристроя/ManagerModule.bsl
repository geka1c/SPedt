#Область ПрограммныйИнтерфейс

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	СтоСП_Печать.ДобавитьКомандыПечатиПоступлений(КомандыПечати);
	
	идентификаторыПечатныхФорм	= 	новый массив();
	идентификаторыПечатныхФорм.Добавить("ПечатьСтикеровПосылки");
//	идентификаторыПечатныхФорм.Добавить("ПечатьСтикеровКоробки");
	
    КомандаПечати 					= КомандыПечати.Добавить();
    КомандаПечати.МенеджерПечати 	= "Документ.ПоступлениеПристроя";
    КомандаПечати.Идентификатор 	= "ПечатьСтикеровПосылки";
    КомандаПечати.Представление 	= НСтр("ru = 'Печать cтикеров'");
    КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 
	
	
	
КонецПроцедуры



Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
#Если Сервер Тогда 

    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьСтикеровПосылки");
    Если НужноПечататьМакет Тогда
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
        КоллекцияПечатныхФорм,
        "ПечатьСтикеровПосылки",
        НСтр("ru = 'Печать cтикеров (Посылки)'"),
        СтоСП_Печать.ТабДок_СтикерПристроя(МассивОбъектов, ОбъектыПечати),
        ,
        "ОбщиеМакеты.ПФ_MXL_ПосылкаЭтикеткаv2");
		
	КонецЕсли;		
	
	//НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьСтикеровКоробки");
	//Если НужноПечататьМакет Тогда
	//    УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
	//    КоллекцияПечатныхФорм,
	//    "ПечатьСтикеровКоробки",
	//    НСтр("ru = 'Печать cтикеров (Коробки)'"),
	//    СтоСП_Печать.ТабДок_СтикерКоробки(МассивОбъектов, ОбъектыПечати),
	//    ,
	//    "ОбщиеМакеты.ПФ_MXL_КоробкаЭтикетка");
	//	
	//	
	//КонецЕсли;			
	
#КонецЕсли 	
КонецПроцедуры



#КонецОбласти




#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	//СтоСПОбмен_Общий.Получить_ТекстЗапроса_Обмен100сп (Запрос, ТекстыЗапроса, Регистры);
//	СтоСПОбмен_Общий.Получить_ТекстЗапроса_Обмен100СП_РН(Запрос, ТекстыЗапроса, Регистры);
	
	Получить_ТекстЗапроса_НеВыгруженноНаСайт(Запрос, ТекстыЗапроса, Регистры);	
	Получить_ТекстЗапроса_Обмен100СПрн_Ошибки (Запрос, ТекстыЗапроса, Регистры);
	
	Получить_ТекстЗапроса_ОстаткиТоваров(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_Приход(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_Транзит(Запрос, ТекстыЗапроса, Регистры);
	
	
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.СвояТочка КАК СвояТочка
	|ИЗ
	|	Документ.ПоступлениеПристроя КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                        Реквизиты.Период);
	Запрос.УстановитьПараметр("СвояТочка",                     Реквизиты.СвояТочка);
	Запрос.УстановитьПараметр("Номер",                         Реквизиты.Номер);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",       ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъекта()));
	Запрос.УстановитьПараметр("ПометкаУдаления",               Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Проведен",                      Реквизиты.Проведен);

КонецПроцедуры

#КонецОбласти

Функция ПолноеИмяОбъекта()
	Возврат "Документ.ПоступлениеПристроя";
КонецФункции


#Область Обмен100сп
Функция ПолучитьТэг_Income(Ссылка,НомерСтроки=Неопределено) Экспорт
	ОтборПоСсылке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&Ссылка) "," = &Ссылка ");
	ОтборПоСтроке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&НомерСтроки) "," = &НомерСтроки ");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
		|	ПоступлениеПристрояЗаказы.МестоХранения 	КАК МестоХранения,
		|	ПоступлениеПристрояЗаказы.Габарит 			КАК Габарит,
		|	""bulletin"" как orderType,
		|	ПоступлениеПристрояЗаказы.Ссылка.Дата 		КАК Дата,
		|	ПоступлениеПристрояЗаказы.ШК 				КАК ШК,
		|	ПоступлениеПристрояЗаказы.Ссылка.Номер 		КАК Номер,
		|	ПоступлениеПристрояЗаказы.Пристрой 			КАК Пристрой,
		|	ПоступлениеПристрояЗаказы.Ссылка.СвояТочка 	КАК СвояТочка
		|ПОМЕСТИТЬ сбор
		|ИЗ
		|	Документ.ПоступлениеПристроя.Заказы КАК ПоступлениеПристрояЗаказы
		|ГДЕ
		|	ПоступлениеПристрояЗаказы.Ссылка "+ОтборПоСсылке+" "+?(НомерСтроки=Неопределено,"", "
		|	И ПоступлениеПристрояЗаказы.НомерСтроки "+ОтборПоСтроке+" ")+"
		
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПоступлениеПристрояЗаявкиНаДоставку.МестоХранения,
		|	ПоступлениеПристрояЗаявкиНаДоставку.Габарит,
		|	""external"" как orderType,
		|	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка.Дата,
		|	ПоступлениеПристрояЗаявкиНаДоставку.ШК,
		|	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка.Номер,
		|	ПоступлениеПристрояЗаявкиНаДоставку.Заявка,
		|	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка.СвояТочка
		|ИЗ
		|	Документ.ПоступлениеПристроя.ЗаявкиНаДоставку КАК ПоступлениеПристрояЗаявкиНаДоставку
		|ГДЕ
		|	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка "+ОтборПоСсылке+" "+?(НомерСтроки=Неопределено,"", "
		|	И ПоступлениеПристрояЗаказы.НомерСтроки "+ОтборПоСтроке+" ") +"
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	сбор.МестоХранения КАК МестоХранения,
		|	сбор.Габарит КАК Габарит,
		|	сбор.orderType КАК orderType,
		|	сбор.Дата КАК Дата,
		|	сбор.ШК КАК ШК,
		|	сбор.Номер КАК Номер,
		|	сбор.Пристрой КАК Пристрой,
		|	сбор.СвояТочка КАК СвояТочка,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Негабарит, ЛОЖЬ) КАК Негабарит,
		|	ЕСТЬNULL(ТарифыСрезПоследних.кодТарифа, -1) КАК кодТарифа
		
		|ИЗ
		|	сбор КАК сбор
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Тарифы.СрезПоследних(&НаДату, ) КАК ТарифыСрезПоследних
		|		ПО сбор.Габарит = ТарифыСрезПоследних.Габарит ";
	
	НаДату = новый Граница(Ссылка.МоментВремени(),ВидГраницы.Исключая);
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("НомерСтроки", НомерСтроки);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат ""; КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Служебный");
	Пока Выборка.Следующий() Цикл
		если Ссылка.ПечатаемСтикер Тогда
			Если ЗначениеЗаполнено(Выборка.ШК) Тогда Продолжить; КонецЕсли;
		Иначе	
			Если не ЗначениеЗаполнено(Выборка.ШК) Тогда Продолжить; КонецЕсли;
		КонецЕсли;	
		ЗаписьXML.ЗаписатьНачалоЭлемента("income");
		
		если Ссылка.ПечатаемСтикер Тогда
			СтоСП.Вставить_Тэг(ЗаписьXML,"stickerId", 			"new");    
		Иначе	
			СтоСП.Вставить_Тэг(ЗаписьXML,"stickerId", 			Формат(Число(Выборка.ШК.Покупка.Код),"ЧГ=0"));    
		КонецЕсли;	
		СтоСП.Вставить_Тэг(ЗаписьXML,"orderId"	, 			Формат(Число(Выборка.Пристрой.Код),"ЧГ=0"));
		СтоСП.Вставить_Тэг(ЗаписьXML,"orderType"	, 		Выборка.orderType);
		
		СтоСП.Вставить_Тэг(ЗаписьXML,"uid"	, 				Формат(Число(Выборка.Пристрой.Участник.Код),"ЧГ=0"));		
		СтоСП.Вставить_Тэг(ЗаписьXML,"date"	,				Выборка.Дата);
		СтоСП.Вставить_Тэг(ЗаписьXML,"arrivalNumber",       Прав(Выборка.Номер,(СтрДлина(Выборка.Номер)-3)));
		СтоСП.Вставить_Тэг(ЗаписьXML,"transit",             ?(Выборка.Пристрой.ТочкаНазначения<>Выборка.СвояТочка,1,0));
		СтоСП.Вставить_Тэг(ЗаписьXML,"tariffId",             Выборка.кодТарифа);
		СтоСП.Вставить_Тэг(ЗаписьXML,"isBig", 				?(Выборка.НеГабарит, 1, 0));
		
		Если ТипЗнч(Выборка.Пристрой) = Тип("СправочникСсылка.ЗаявкаНаДоставку") Тогда
			СтоСП.Вставить_Тэг(ЗаписьXML,"estimatedCost", 	Выборка.Пристрой.ОценочнаяСтоимость);
			СтоСП.Вставить_Тэг(ЗаписьXML,"content", 		Выборка.Пристрой.Описание);
		КонецЕсли;	
		//СтоСПОбмен_Общий.ЗаполнитьТэгиЗаказаПо_ШК(Выборка.ШК,ЗаписьXML);	
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
    ЗаписьXML.ЗаписатьКонецЭлемента();
	рез=ЗаписьXML.Закрыть();
	рез=СтрЗаменить(рез,"<Служебный>","");
	рез=СтрЗаменить(рез,"</Служебный>","");
	Возврат рез;
КонецФункции
#КонецОбласти



Функция Получить_ТекстЗапроса_НеВыгруженноНаСайт(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "НеВыгруженноНаСайт";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если ТипЗнч(Запрос.Параметры.Ссылка)=Тип("ДокументСсылка.ПоступлениеПристроя") Тогда
		 ТекстЗапроса = "ВЫБРАТЬ
		                |	ПоступлениеПристрояЗаказы.Ссылка.Дата КАК Период,
		                |	ПоступлениеПристрояЗаказы.ШК.Покупка КАК Заказ,
		                |	ПоступлениеПристрояЗаказы.МестоХранения КАК МестоХранения,
						//|	ПоступлениеПристрояЗаказы.Габарит КАК Габарит,
						//|	ЗНАЧЕНИЕ(Справочник.Коробки.БезКоробки) КАК Коробка,
		                |	ПоступлениеПристрояЗаказы.ШК.ПунктВыдачи КАК ПунктВыдачи,
		                |	ПоступлениеПристрояЗаказы.Ссылка КАК Партия,
		                |	1 КАК Количество
		                |ИЗ
		                |	Документ.ПоступлениеПристроя.Заказы КАК ПоступлениеПристрояЗаказы
		                |ГДЕ
		                |	ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
						|	И НЕ ПоступлениеПристрояЗаказы.Ссылка.ПечатаемСтикер
		                |	И НЕ ПоступлениеПристрояЗаказы.Ссылка.Отправлено
		                |
		                |ОБЪЕДИНИТЬ ВСЕ
		                |
		                |ВЫБРАТЬ
		                |	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка.Дата,
		                |	ПоступлениеПристрояЗаявкиНаДоставку.ШК.Покупка,
		                |	ПоступлениеПристрояЗаявкиНаДоставку.МестоХранения,
						//|	ПоступлениеПристрояЗаявкиНаДоставку.Габарит,
						//|	ЗНАЧЕНИЕ(Справочник.Коробки.БезКоробки),
		                |	ПоступлениеПристрояЗаявкиНаДоставку.ШК.ПунктВыдачи,
		                |	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка,
		                |	1
		                |ИЗ
		                |	Документ.ПоступлениеПристроя.ЗаявкиНаДоставку КАК ПоступлениеПристрояЗаявкиНаДоставку
		                |ГДЕ
		                |	ПоступлениеПристрояЗаявкиНаДоставку.Ссылка = &Ссылка
						|	И НЕ ПоступлениеПристрояЗаявкиНаДоставку.Ссылка.ПечатаемСтикер
		                |	И НЕ ПоступлениеПристрояЗаявкиНаДоставку.Отправлено";
	КонецЕсли;	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция Получить_ТекстЗапроса_Обмен100СПрн_Ошибки (Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "Обмен100СПрн_Ошибки";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	//Если Запрос.Параметры.Статус<>Перечисления.СтатусОтпавкиНаСайт.Отправлен Тогда
	//	Возврат "";
	//КонецЕсли; 
	
	ТекстЗапроса =  "
					|
					|ВЫБРАТЬ
	                |	ПоступлениеПристрояЗаказы.Ссылка.Дата 		КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) 		КАК ВидДвижения,
	                |	ЗНАЧЕНИЕ(Перечисление.ТипыОбменов100сп.ПоступлениеПристроя) КАК типОбмена,
	                |	ПоступлениеПристрояЗаказы.Ссылка 			КАК Партия,
	                |	ПоступлениеПристрояЗаказы.НомерСтроки 		КАК СтрокаВПартии,
	                |	ПоступлениеПристрояЗаказы.ШК 				КАК Мегаордер,
	                |	""Не привязан стикер к пристрою!"" 					КАК СообщениеОшибки,
	                |	1 КАК КоличествоНеИсправленных
	                |ИЗ
	                |	Документ.ПоступлениеПристроя.Заказы КАК ПоступлениеПристрояЗаказы
	                |ГДЕ
	                |	ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
	                |	И НЕ ПоступлениеПристрояЗаказы.Отправлено
	                |
				    |ОБЪЕДИНИТЬ ВСЕ
	                |
					|ВЫБРАТЬ
	                |	ПоступлениеПристрояЗаказы.Ссылка.Дата 		КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) 		КАК ВидДвижения,
	                |	ЗНАЧЕНИЕ(Перечисление.ТипыОбменов100сп.ПоступлениеПристроя) КАК типОбмена,
	                |	ПоступлениеПристрояЗаказы.Ссылка 			КАК Партия,
	                |	ПоступлениеПристрояЗаказы.НомерСтроки 		КАК СтрокаВПартии,
	                |	ПоступлениеПристрояЗаказы.ШК 				КАК Мегаордер,
	                |	""Не привязан стикер к заявке на доставку!"" 					КАК СообщениеОшибки,
	                |	1 КАК КоличествоНеИсправленных
	                |ИЗ
	                |	Документ.ПоступлениеПристроя.ЗаявкиНаДоставку КАК ПоступлениеПристрояЗаказы
	                |ГДЕ
	                |	ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
	                |	И НЕ ПоступлениеПристрояЗаказы.Отправлено
					
					|
					|";
	
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
КонецФункции


Функция Получить_ТекстЗапроса_ОстаткиТоваров(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "ОстаткиТоваров";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если ТипЗнч(Запрос.Параметры.Ссылка)=Тип("ДокументСсылка.ПоступлениеПристроя") Тогда
		ТекстЗапроса ="ВЫБРАТЬ
		              |	ПоступлениеПристрояЗаказы.Ссылка.Дата КАК Период,
		              |	ПоступлениеПристрояЗаказы.ШК.Покупка КАК Покупка,
		              |	ПоступлениеПристрояЗаказы.МестоХранения КАК МестоХранения,
		              |	ПоступлениеПристрояЗаказы.Габарит КАК Габарит,
		              |	ПоступлениеПристрояЗаказы.Пристрой.Участник КАК Участник,
		              |	ИСТИНА КАК Оплачен,
		              |	ПоступлениеПристрояЗаказы.Ссылка КАК Партия,
		              |	1 КАК Количество
		              |ИЗ
		              |	Документ.ПоступлениеПристроя.Заказы КАК ПоступлениеПристрояЗаказы
		              |ГДЕ
		              |	ПоступлениеПристрояЗаказы.Пристрой.ТочкаНазначения = &СвояТочка
		              |	И ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
		              |	И ПоступлениеПристрояЗаказы.Отправлено
		              |
		              |ОБЪЕДИНИТЬ ВСЕ
		              |
		              |ВЫБРАТЬ
		              |	ПоступлениеПристрояЗаказы.Ссылка.Дата,
		              |	ПоступлениеПристрояЗаказы.ШК.Покупка,
		              |	ПоступлениеПристрояЗаказы.МестоХранения,
		              |	ПоступлениеПристрояЗаказы.Габарит,
		              |	ПоступлениеПристрояЗаказы.Заявка.Участник,
		              |	ИСТИНА,
		              |	ПоступлениеПристрояЗаказы.Ссылка,
		              |	1
		              |ИЗ
		              |	Документ.ПоступлениеПристроя.ЗаявкиНаДоставку КАК ПоступлениеПристрояЗаказы
		              |ГДЕ
		              |	ПоступлениеПристрояЗаказы.Заявка.ТочкаНазначения = &СвояТочка
		              |	И ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
		              |	И ПоступлениеПристрояЗаказы.Отправлено";					  
					  
					  
	КонецЕсли;	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция Получить_ТекстЗапроса_Приход(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "Приход";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если ТипЗнч(Запрос.Параметры.Ссылка)=Тип("ДокументСсылка.ПоступлениеПристроя") Тогда
		ТекстЗапроса = "ВЫБРАТЬ
		               |	ПоступлениеПристрояЗаказы.Ссылка.Дата 				КАК Период,
		               |	ПоступлениеПристрояЗаказы.Габарит 					КАК Габарит,
		               |	ПоступлениеПристрояЗаказы.МестоХранения 			КАК МестоХранения,
		               |	ПоступлениеПристрояЗаказы.ШК.Покупка.Организатор 	КАК Организатор,
		               |	ПоступлениеПристрояЗаказы.ШК.Покупка 				КАК Покупка,
		               |	1 													КАК Количество,
		               |	ПоступлениеПристрояЗаказы.ШК.ПунктВыдачи			КАК ПунктВыдачи,
		               |	ЗНАЧЕНИЕ(Справочник.Коробки.БезКоробки) 			КАК Коробка,
		               |	ВЫБОР
		               |		КОГДА ПоступлениеПристрояЗаказы.Пристрой.ТочкаНазначения = &СвояТочка
		               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыПриходов.ПристройНаСклад)
		               |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыПриходов.ПристройНаТранзит)
		               |	КОНЕЦ 												КАК ТипПрихода,
		               |	ПоступлениеПристрояЗаказы.Пристрой.Участник КАК Участник,
		               |	ПоступлениеПристрояЗаказы.Сумма КАК Сумма
		               |ИЗ
		               |	Документ.ПоступлениеПристроя.Заказы КАК ПоступлениеПристрояЗаказы
		               |ГДЕ
		               |	ПоступлениеПристрояЗаказы.Отправлено
		               |	И ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
		               |
		               |ОБЪЕДИНИТЬ ВСЕ
		               |
		               |ВЫБРАТЬ
		               |	ПоступлениеПристрояЗаказы.Ссылка.Дата,
		               |	ПоступлениеПристрояЗаказы.Габарит,
		               |	ПоступлениеПристрояЗаказы.МестоХранения,
		               |	ПоступлениеПристрояЗаказы.ШК.Покупка.Организатор,
		               |	ПоступлениеПристрояЗаказы.ШК.Покупка,
		               |	1,
		               |	ПоступлениеПристрояЗаказы.ШК.ПунктВыдачи,
		               |	ЗНАЧЕНИЕ(Справочник.Коробки.БезКоробки),
		               |	ВЫБОР
		               |		КОГДА ПоступлениеПристрояЗаказы.Заявка.ТочкаНазначения = &СвояТочка
		               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыПриходов.ПристройНаСклад)
		               |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыПриходов.ПристройНаТранзит)
		               |	КОНЕЦ,
		               |	ПоступлениеПристрояЗаказы.Заявка.Участник,
		               |	ПоступлениеПристрояЗаказы.Сумма
		               |ИЗ
		               |	Документ.ПоступлениеПристроя.ЗаявкиНаДоставку КАК ПоступлениеПристрояЗаказы
		               |ГДЕ
		               |	ПоступлениеПристрояЗаказы.Отправлено
		               |	И ПоступлениеПристрояЗаказы.Ссылка = &Ссылка";
					   
					   
	КонецЕсли;	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция Получить_ТекстЗапроса_Транзит(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "Транзит";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если ТипЗнч(Запрос.Параметры.Ссылка)=Тип("ДокументСсылка.ПоступлениеПристроя") Тогда
		ТекстЗапроса = "ВЫБРАТЬ
		               |	ПоступлениеПристрояЗаказы.Ссылка.Дата КАК Период,
		               |	ПоступлениеПристрояЗаказы.ШК.Покупка КАК ПокупкаСсылка,
		               |	ПоступлениеПристрояЗаказы.МестоХранения КАК МестоХранения,
		               |	ПоступлениеПристрояЗаказы.Габарит КАК Габарит,
		               |	ПоступлениеПристрояЗаказы.Пристрой.Участник КАК Участник,
		               |	ПоступлениеПристрояЗаказы.ПВТранзита КАК Точка,
		               |	ПоступлениеПристрояЗаказы.Ссылка КАК Партия,
		               |	1 КАК Количество
		               |ИЗ
		               |	Документ.ПоступлениеПристроя.Заказы КАК ПоступлениеПристрояЗаказы
		               |ГДЕ
		               |	ПоступлениеПристрояЗаказы.Отправлено
		               |	И НЕ ПоступлениеПристрояЗаказы.Пристрой.ТочкаНазначения = &СвояТочка
		               |	И ПоступлениеПристрояЗаказы.Ссылка = &Ссылка
		               |
		               |ОБЪЕДИНИТЬ ВСЕ
		               |
		               |ВЫБРАТЬ
		               |	ПоступлениеПристрояЗаказы.Ссылка.Дата,
		               |	ПоступлениеПристрояЗаказы.ШК.Покупка,
		               |	ПоступлениеПристрояЗаказы.МестоХранения,
		               |	ПоступлениеПристрояЗаказы.Габарит,
		               |	ПоступлениеПристрояЗаказы.Заявка.Участник,
		               |	ПоступлениеПристрояЗаказы.ПВТранзита,
		               |	ПоступлениеПристрояЗаказы.Ссылка,
		               |	1
		               |ИЗ
		               |	Документ.ПоступлениеПристроя.ЗаявкиНаДоставку КАК ПоступлениеПристрояЗаказы
		               |ГДЕ
		               |	ПоступлениеПристрояЗаказы.Отправлено
		               |	И НЕ ПоступлениеПристрояЗаказы.Заявка.ТочкаНазначения = &СвояТочка
		               |	И ПоступлениеПристрояЗаказы.Ссылка = &Ссылка";
	КонецЕсли;	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

