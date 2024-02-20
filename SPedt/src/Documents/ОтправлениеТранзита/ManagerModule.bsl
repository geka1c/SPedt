
#Область Печать
// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//КомандаПечати = КомандыПечати.Добавить();
	//КомандаПечати.МенеджерПечати = "Документ.ОтправлениеТранзита";
	//КомандаПечати.Идентификатор = "КвитанцияПР";
	//КомандаПечати.Представление = НСтр("ru = 'Квитанция Почта России'");
	//КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 	
	
	
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.МенеджерПечати = "Документ.ОтправлениеТранзита";
    КомандаПечати.Идентификатор = "СписокПР";
    КомандаПечати.Представление = НСтр("ru = 'Список Почта России'");
    КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 	
	
	 // Опись коробки
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.МенеджерПечати = "Документ.ОтправлениеТранзита";
    КомандаПечати.Идентификатор = "ЧекПросмотр";
	КомандаПечати.Картинка = БиблиотекаКартинок.Печать;
    КомандаПечати.Представление = НСтр("ru = 'Чек просмотр'");
   // КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 
	
	
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.МенеджерПечати = "Документ.ОтправлениеТранзита";
    КомандаПечати.Идентификатор = "Чек";
	КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
    КомандаПечати.Представление = НСтр("ru = 'Чек'");
	КомандаПечати.СразуНаПринтер=истина;
	
	
	КомандаПечати 							= КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати 			= "Документ.ОтправлениеТранзита";
	КомандаПечати.Идентификатор 			= "ЧекНЗ";
	КомандаПечати.Картинка 					= БиблиотекаКартинок.Печать;
	КомандаПечати.обработчик				= "СтоСП_Печать_Клиент.ЧекНЗОтправлениеТранзита";
	КомандаПечати.Представление 			= НСтр("ru = 'Чек НЗ'");
	КомандаПечати.НеВыполнятьЗаписьВФорме	= Истина;	
	
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  – Массив    – ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати – Структура – дополнительные настройки печати;
//  КоллекцияПечатныхФорм – ТаблицаЗначений – сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         – СписокЗначений  – значение – ссылка на объект;
//                                            представление – имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       – Структура       – дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
#Если Сервер Тогда
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КвитанцияПР");
	Если НужноПечататьМакет Тогда
		//об=Обработки.ОбменСПочтойРоссии.Создать();
		//СсылкаНаКвитанцию=об.ОбменССайтомКвитанцияФ103(МассивОбъектов); 
		//СП_клиент.ЗапутитьПрилож(СсылкаНаКвитанцию);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"КвитанцияПР",
		НСтр("ru = 'КвитанцияПР'"),
		ПечатьКвитанцияПР(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ОтправлениеТранзита.ПФ_MXL_КвитанцияПР");
	КонецЕсли;	
	
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокПР");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"СписокПР",
		НСтр("ru = 'СписокПР'"),
		ПечатьСписокПР(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ОтправлениеТранзита.ПФ_MXL_СисокФР");

	КонецЕсли;	
	
   НужноПечататьМакет 		= УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Чек");

    Если НужноПечататьМакет Тогда
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
        КоллекцияПечатныхФорм,
        "Чек",
        НСтр("ru = 'Чек'"),
        ПечатьЧек(МассивОбъектов, ОбъектыПечати),
        ,
        "Документ.Расходная.ПФ_MXL_Чек");
	КонецЕсли;	
	
   НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЧекПросмотр");

    Если НужноПечататьМакет Тогда
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
        КоллекцияПечатныхФорм,
        "ЧекПросмотр",
        НСтр("ru = 'Чек просмотр'"),
        ПечатьЧек(МассивОбъектов, ОбъектыПечати),
        ,
        "Документ.Расходная.ПФ_MXL_Чек");
	КонецЕсли;	
	
#КонецЕсли 	
КонецПроцедуры

Функция ПечатьКвитанцияПР(МассивОбъектов, ОбъектыПечати) Экспорт
	ТабДок= Новый ТабличныйДокумент;
	Макет = Документы.ОтправлениеТранзита.ПолучитьМакет("ПФ_MXL_КвитанцияПР");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтправлениеТранзита.Ссылка
	|ИЗ
	|	Документ.ОтправлениеТранзита КАК ОтправлениеТранзита
	|ГДЕ
	|	ОтправлениеТранзита.Ссылка В(&Ссылка)";
	
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	Квитанция = Макет.ПолучитьОбласть("Квитанция");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		//ОбластьПокупки.Параметры.Заполнить(ВыборкаПокупки);
		ТабДок.Вывести(Квитанция);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
	Возврат ТабДок;
КонецФункции

Функция ПечатьСписокПР(МассивОбъектов, ОбъектыПечати) Экспорт
	ТабДок= Новый ТабличныйДокумент;
	Макет = Документы.ОтправлениеТранзита.ПолучитьМакет("ПФ_MXL_СисокФР");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтправлениеТранзита.Ссылка
	|ИЗ
	|	Документ.ОтправлениеТранзита КАК ОтправлениеТранзита
	|ГДЕ
	|	ОтправлениеТранзита.Ссылка В(&Ссылка)";
	
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();
	ТабДок.Очистить();

	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Вывести(ОбластьШапка);
	
	ВставлятьРазделительСтраниц = Ложь;
	нпп=1;
	СтоимостьИтого=0;
	НаложенныйлатежИтого=0;
	Пока Выборка.Следующий() Цикл
		//Если ВставлятьРазделительСтраниц Тогда
		//	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		//КонецЕсли;                                                                  
		//ОбластьПокупки.Параметры.Заполнить(ВыборкаПокупки);
		ОбластьСтрока.Параметры.нпп      		= нпп;
		ОбластьСтрока.Параметры.Адресат         = Выборка.Ссылка.Индекс+", "+Выборка.Ссылка.Город+", "+Выборка.Ссылка.Регион+", "+Выборка.Ссылка.Адрес+","+Выборка.Ссылка.ФИО;
		ОбластьСтрока.Параметры.Вес             = Выборка.Ссылка.Вес/1000;
		ОбластьСтрока.Параметры.Стоимость       =  Выборка.Ссылка.ИтогоСтоимость;
		ОбластьСтрока.Параметры.Наложенныйлатеж =  Выборка.Ссылка.ИтогоСтоимость;
		ТабДок.Вывести(ОбластьСтрока);
		СтоимостьИтого=СтоимостьИтого				+ Выборка.Ссылка.ИтогоСтоимость;
		НаложенныйлатежИтого=НаложенныйлатежИтого	+ Выборка.Ссылка.ИтогоСтоимость;
//		ВставлятьРазделительСтраниц = Истина;
		нпп=нпп+1;
	КонецЦикла;
	ОбластьПодвал.Параметры.Стоимость       = СтоимостьИтого;
	ОбластьПодвал.Параметры.Наложенныйлатеж = НаложенныйлатежИтого;
	
	ТабДок.Вывести(ОбластьПодвал);
	
	Возврат ТабДок;
КонецФункции

Функция ПечатьЧек(МассивОбъектов, ОбъектыПечати) 
	#Если Сервер Тогда
		// Создаем табличный документ и устанавливаем имя параметров печати.
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.АвтоМасштаб=Истина;
		ТабличныйДокумент.ПолеСлева=0;
		ТабличныйДокумент.ПолеСправа=0;	 
		ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_Чек";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтправлениеТранзита.ПФ_MXL_Чек");

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтправлениеТранзита.Дата,
	|	ОтправлениеТранзита.Номер,
	|	ОтправлениеТранзита.ТочкаНазначения,
	|	ОтправлениеТранзита.Участник,
	|	ОтправлениеТранзита.ФИО,
	|	ОтправлениеТранзита.Заказы.(
	|		Покупка КАК Покупка,
	|		Покупка.Код КАК КодПокупки,	
	|		ЕСТЬNULL(ОтправлениеТранзита.Заказы.МестоХранения.Родитель.Наименование, """") + ""   \   "" + ОтправлениеТранзита.Заказы.МестоХранения.Наименование КАК МестоХранения,
	|		Партия,
	|		ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(ОтправлениеТранзита.Заказы.Покупка) = ТИП(Справочник.Покупки)
	|				ТОГДА ОтправлениеТранзита.Заказы.Покупка.Владелец
	|			ИНАЧЕ ОтправлениеТранзита.Заказы.Покупка.Организатор
	|		КОНЕЦ КАК Организатор,
	|		ВремяХранения,
	|		СтоимостьХранения,
	|		Габарит,
	|		Количество
	|	)	
	|ИЗ
	|	Документ.ОтправлениеТранзита КАК ОтправлениеТранзита
	|ГДЕ
	|	ОтправлениеТранзита.Ссылка В(&МассивОбъектов)";
	
     Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
     Выборка = Запрос.Выполнить().Выбрать();
     ПервыйДокумент = Истина;
	
	ОбластьШапка 		= Макет.ПолучитьОбласть("Шапка");
	ОбластьПокупки 		= Макет.ПолучитьОбласть("Покупки");
	ОбластьПодвал 		= Макет.ПолучитьОбласть("Подвал");
	
	
	
	ТабличныйДокумент.Очистить();
	ВставлятьРазделительСтраниц = Ложь;
	Итого=0;
	Пока Выборка.Следующий() Цикл
         Если Не ПервыйДокумент Тогда
             ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
         КонецЕсли;
         ПервыйДокумент = Ложь;

		ОбластьШапка.Параметры.Заполнить(Выборка);
    	ОбластьШапка.Параметры.Дата=Формат(Выборка.Дата,"ДЛФ=ДД");
		ОбластьШапка.Параметры.НазваниеОрганизации=Константы.НазваниеОрганизации.Получить();
		ТабличныйДокумент.Вывести(ОбластьШапка, Выборка.Уровень());

		//ТабДок.Вывести(ОбластьПокупкиШапка);
		нпп=1;
		
		ВыборкаПокупки = Выборка.Заказы.Выбрать();
		Пока ВыборкаПокупки.Следующий() Цикл
			УменьшаемоеКоличество=ВыборкаПокупки.Количество;
			УмКоличество=ВыборкаПокупки.Количество;
			Пока УменьшаемоеКоличество>0 Цикл
				ОбластьПокупки.Параметры.Заполнить(ВыборкаПокупки);
				ОбластьПокупки.Параметры.нпп=нпп;
				ОбластьПокупки.Параметры.Организатор=ВыборкаПокупки.Организатор;
				ТабличныйДокумент.Вывести(ОбластьПокупки, ВыборкаПокупки.Уровень());
			//	ОбластьПокупки.Параметры.СтоимостьХранения=ВыборкаПокупки.СтоимостьХранения/УмКоличество;
			//	Итого= Итого+ОбластьПокупки.Параметры.СтоимостьХранения;
				нпп=нпп+1;
				УменьшаемоеКоличество=УменьшаемоеКоличество-1
			КонеццИКЛА;
		КонецЦикла;
		
		
		ОбластьПодвал.Параметры.Заполнить(Выборка);
		//ОбластьПодвал.Параметры.Итого=Итого;
		ТабличныйДокумент.Вывести(ОбластьПодвал);
	КонецЦикла;
	
	
     Возврат ТабличныйДокумент;
	 #КонецЕсли

	
КонецФункции

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
	Получить_ТекстЗапроса_Транзит(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_ЗаказыВПосылках(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
	
КонецПроцедуры
Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ОтправлениеТранзита КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                                         Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                         Реквизиты.Номер);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",       ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъекта()));
	Запрос.УстановитьПараметр("Комментарий",                   Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("ПометкаУдаления",               Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Проведен",                      Реквизиты.Проведен);
КонецПроцедуры

Функция Получить_ТекстЗапроса_Транзит(Запрос, ТекстыЗапроса, Регистры) 
	ИмяРегистра = "Транзит";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если ТипЗнч(Запрос.Параметры.Ссылка)=Тип("ДокументСсылка.ОтправлениеТранзита") Тогда
		ТекстЗапроса = "
		|
		|ВЫБРАТЬ
		|	ОтправлениеТранзитаЗаказы.Ссылка.Дата КАК Период,
		|	ОтправлениеТранзитаЗаказы.Покупка КАК ПокупкаСсылка,
		|	Значение(ВидДвиженияНакопления.Расход) как ВидДвижения,
		|	ОтправлениеТранзитаЗаказы.МестоХранения КАК МестоХранения,
		|	ОтправлениеТранзитаЗаказы.Габарит КАК Габарит,
		|	ОтправлениеТранзитаЗаказы.Ссылка.Участник КАК Участник,
		|	ОтправлениеТранзитаЗаказы.Точка КАК Точка,
		|	ОтправлениеТранзитаЗаказы.Партия КАК Партия,
		|	ОтправлениеТранзитаЗаказы.Количество КАК Количество
		|ИЗ
		|	Документ.ОтправлениеТранзита.Заказы КАК ОтправлениеТранзитаЗаказы
		|ГДЕ
		|	ОтправлениеТранзитаЗаказы.Посылка = Значение(Справочник.Посылки.ПустаяСсылка) и
		|	ОтправлениеТранзитаЗаказы.Ссылка=&Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|
		|ВЫБРАТЬ
		|	ОтправлениеТранзитаЗаказы.Ссылка.Дата,
		|	ОтправлениеТранзитаЗаказы.Посылка,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
		|	ОтправлениеТранзитаЗаказы.МестоХранения,
		|	ОтправлениеТранзитаЗаказы.Габарит,
		|	ОтправлениеТранзитаЗаказы.Ссылка.Участник,
		|	ОтправлениеТранзитаЗаказы.Точка,
		|	ОтправлениеТранзитаЗаказы.Партия,
		|	МАКСИМУМ(ОтправлениеТранзитаЗаказы.Количество)
		|ИЗ
		|	Документ.ОтправлениеТранзита.Заказы КАК ОтправлениеТранзитаЗаказы
		|ГДЕ
		|	ОтправлениеТранзитаЗаказы.Посылка <> ЗНАЧЕНИЕ(Справочник.Посылки.ПустаяСсылка) и
		|	ОтправлениеТранзитаЗаказы.Ссылка=&Ссылка		
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтправлениеТранзитаЗаказы.Ссылка.Дата,
		|	ОтправлениеТранзитаЗаказы.Посылка,
		|	ОтправлениеТранзитаЗаказы.Ссылка.Участник,
		|	ОтправлениеТранзитаЗаказы.Точка,
		|	ОтправлениеТранзитаЗаказы.МестоХранения,
		|	ОтправлениеТранзитаЗаказы.Партия,
		|	ОтправлениеТранзитаЗаказы.Габарит
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОтправлениеТранзита.Ссылка.Дата КАК Период,
		|	ОтправлениеТранзита.Коробка КАК ПокупкаСсылка,
		|	Значение(ВидДвиженияНакопления.Приход) как ВидДвижения,
		|	ОтправлениеТранзита.МестоХранения КАК МестоХранения,
		|	ОтправлениеТранзита.Габарит КАК Габарит,
		|	ОтправлениеТранзита.Участник КАК Участник,
		|	ОтправлениеТранзита.ТочкаНазначения КАК Точка,
		|	ОтправлениеТранзита.Ссылка КАК Партия,
		|	1 КАК Количество
		|ИЗ
		|	Документ.ОтправлениеТранзита КАК ОтправлениеТранзита
		|ГДЕ
		|	ОтправлениеТранзита.Коробка <> Значение(Справочник.Коробки.ПустаяСсылка) и
		|	ОтправлениеТранзита.Ссылка=&Ссылка
		
		|
		|";
	КонецЕсли;	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции
Функция Получить_ТекстЗапроса_ЗаказыВПосылках(Запрос, ТекстыЗапроса, Регистры) 
	ИмяРегистра = "ЗаказыВПосылках";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если ТипЗнч(Запрос.Параметры.Ссылка)=Тип("ДокументСсылка.ОтправлениеТранзита") Тогда
		ТекстЗапроса = "
		|
		|
		|ВЫБРАТЬ
		|	&Период КАК Период,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	ЗаказыВПосылкахОстатки.Покупка КАК Покупка,
		|	ЗаказыВПосылкахОстатки.Участник КАК Участник,
		|	ЗаказыВПосылкахОстатки.КодЗаказа КАК КодЗаказа,
		|	ЗаказыВПосылкахОстатки.Посылка КАК Посылка,
		|	ЗаказыВПосылкахОстатки.Партия КАК Партия,
		|	ЗаказыВПосылкахОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ЗаказыВПосылках.Остатки(
		|			ДОБАВИТЬКДАТЕ(&Период, СЕКУНДА, -1),
		|			Посылка В
		|				(ВЫБРАТЬ
		|					ОтправлениеТранзитаЗаказы.Посылка КАК Посылка
		|				ИЗ
		|					Документ.ОтправлениеТранзита.Заказы КАК ОтправлениеТранзитаЗаказы
		|				ГДЕ
		|					ОтправлениеТранзитаЗаказы.Посылка <> ЗНАЧЕНИЕ(Справочник.Посылки.ПустаяСсылка)
		|					И ОтправлениеТранзитаЗаказы.Ссылка = &Ссылка)) КАК ЗаказыВПосылкахОстатки		
		|
		|";
	КонецЕсли;	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти



#Область Заполнение
Процедура ЗаполнитьОстатками(Объект, Параметры) Экспорт

	Если Не ЗначениеЗаполнено(Параметры.ГруппаДоставки) 
		и ЗначениеЗаполнено(объект.Коробка)
		и объект.Коробка.ВидСтикера = Перечисления.ВидыСтикеров.ГруппаДоставки 
		и объект.Вес = 0
		и объект.Длина = 0
		и объект.Ширина = 0
		и объект.высота = 0
		
		Тогда
		Объект.Заказы.Очистить();
		Параметры.ГруппаДоставки = объект.Коробка;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Параметры.ГруппаДоставки) Тогда     //Отправка групп доставки
		
		ЗаполнитьГруппуДоставки(Объект,Параметры.ГруппаДоставки);
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.Заказы)  Тогда				//Отправка одиночных заказов
		
		ЗаполнитьОдиночныеЗаказы(Объект,Параметры)
		
	КонецЕсли;
	
	Объект.ОбъявленнаяСтоимость		= ПолучитьОбъявленнуюСтоимость(Объект);
КонецПроцедуры

Функция ПолучитьОбъявленнуюСтоимость(Объект) Экспорт
	КодыЗаказов = Новый СписокЗначений;
    Для каждого Элем из Объект.Заказы Цикл
		КодыЗаказов.Добавить(Элем.КодЗаказа);
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КоробкиСостав.КодЗаказа КАК КодЗаказа,
		|	МАКСИМУМ(КоробкиСостав.Цена) КАК Цена
		|ПОМЕСТИТЬ втВыборка
		|ИЗ
		|	Справочник.Коробки.Состав КАК КоробкиСостав
		|ГДЕ
		|	КоробкиСостав.Ссылка = &Ссылка и КоробкиСостав.КодЗаказа в (&КодыЗаказов)
		|
		|СГРУППИРОВАТЬ ПО
		|	КоробкиСостав.КодЗаказа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(втВыборка.Цена) КАК Цена
		|ИЗ
		|	втВыборка КАК втВыборка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Коробка);
	Запрос.УстановитьПараметр("КодыЗаказов", КодыЗаказов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Цена;
	КонецЕсли;
	
	Возврат 0;
	
	
КонецФункции

Процедура ЗаполнитьГруппуДоставки(Объект,ГруппаДоставки)
	Объект.Коробка			= ГруппаДоставки;
	объект.ТочкаНазначения	= ГруппаДоставки.ТочкаНазначения;
	Объект.Участник			= ГруппаДоставки.УчастникГД;
	
	тзСостав	= ГруппаДоставки.Состав.Выгрузить(новый Структура("Исключить, Удалить",Ложь,ложь),"Покупка, Участник, КодЗаказа, Цена");
	Если тзСостав.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В "+ГруппаДоставки+" нет заказов!");
		Возврат;
	КонецЕсли;
	
	тзСостав.Свернуть("Покупка, Участник, КодЗаказа", "Цена");
	тз_СтоимостьИРасположениеЗаказов =	Получить_СтоимостьИРасположениеЗаказовГруппыДоставки(тзСостав,объект.ТочкаНазначения);
	
	Для каждого Стр из тзСостав Цикл
		массСтрок	= тз_СтоимостьИРасположениеЗаказов.НайтиСтроки(новый Структура("КодЗаказа",Стр.КодЗаказа));
		Если массСтрок.Количество()=0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("На складе НЕ найдено позиций для "+Символы.ПС+"участник: "+стр.Участник+Символы.ПС+", покупка: "+Стр.Покупка+Символы.ПС);
		Конецесли;	
		Если массСтрок.Количество()>1 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("На складе найдено несколько позиций для "+стр.Участник+", "+стр.Покупка+Символы.ПС+"Добавлены все");
		КонецЕсли;
		Для каждого элем из массСтрок Цикл
			стрЗаказа=Объект.Заказы.Добавить();
			ЗаполнитьЗначенияСвойств(стрЗаказа,элем);
			
			Если элем.Количество=0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("На складе НЕ найдено позиций для "+Символы.ПС+"участник: "+стр.Участник+Символы.ПС+", покупка: "+Стр.Покупка+Символы.ПС,,"Объект.Заказы["+(стрЗаказа.НомерСтроки-1)+"].Покупка" );					
			КонецЕсли;
			Если элем.ДругойПВ Тогда
				//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ принят для другого ПВ "+Символы.ПС+"участник: "+стр.Участник+Символы.ПС+", покупка: "+Стр.Покупка+Символы.ПС,,"Объект.Заказы["+(стрЗаказа.НомерСтроки-1)+"].Покупка" );					
			КонецЕсли;					
		КонецЦикла;
	КонецЦикла;	
		
	
КонецПроцедуры


Процедура ЗаполнитьОдиночныеЗаказы(Объект,Параметры)
	Объект.Участник			= Параметры.Участник;
	объект.ТочкаНазначения	= Параметры.ТочкаНазначения;
	
	тз=ДанныеФормыВЗначение(Параметры.Заказы,Тип("ТаблицаЗначений"));

	ТЗСостав=тз.скопировать(Новый Структура("Подбор",Истина),"Покупка");
	ТЗСостав.Колонки.Добавить("Цена",		Новый ОписаниеТипов("Число"));
	ТЗСостав.Колонки.Добавить("Участник",	Новый ОписаниеТипов("СправочникСсылка.Участники"));
	ТЗСостав.ЗаполнитьЗначения(0,"Цена");
	ТЗСостав.ЗаполнитьЗначения(Параметры.Участник,"Участник");
	
	тзСостав.Свернуть("Покупка, Участник", "Цена");
	тз_СтоимостьИРасположениеЗаказов =	Получить_СтоимостьИРасположениеОдиночныхЗаказов(тзСостав,объект.ТочкаНазначения);
	
	Для каждого Стр из тзСостав Цикл
		массСтрок=тз_СтоимостьИРасположениеЗаказов.НайтиСтроки(новый Структура("Покупка, Участник",Стр.Покупка, Стр.Участник));
		Если массСтрок.Количество()=0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("На складе НЕ найдено позиций для "+Символы.ПС+"участник: "+стр.Участник+Символы.ПС+", покупка: "+Стр.Покупка+Символы.ПС);
		Конецесли;	
		Если массСтрок.Количество()>1 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("На складе найдено несколько позиций для "+стр.Участник+", "+стр.Покупка+Символы.ПС+"Добавлены все");
		КонецЕсли;
		Для каждого элем из массСтрок Цикл
			стрЗаказа=Объект.Заказы.Добавить();
			ЗаполнитьЗначенияСвойств(стрЗаказа,элем);
			
			Если элем.Количество=0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("На складе НЕ найдено позиций для "+Символы.ПС+"участник: "+стр.Участник+Символы.ПС+", покупка: "+Стр.Покупка+Символы.ПС,,"Объект.Заказы["+(стрЗаказа.НомерСтроки-1)+"].Покупка" );					
			КонецЕсли;
			Если элем.ДругойПВ Тогда
				//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ принят для другого ПВ "+Символы.ПС+"участник: "+стр.Участник+Символы.ПС+", покупка: "+Стр.Покупка+Символы.ПС,,"Объект.Заказы["+(стрЗаказа.НомерСтроки-1)+"].Покупка" );					
			КонецЕсли;					
		КонецЦикла;
	КонецЦикла;		
	
КонецПроцедуры




// Получить места хранеия заказов для переданой ТаблицыЗаказов. 
// Если заказ в посылке ищется с учетом кода закказа
// если поступило покупкой то код заказа пустаяя строка
//
// Параметры:
//  таблицаЗаказов  - ТаблицаЗначений - 
//  ТочкаНазначения - СправочникСсылка.ТочкиРаздачи -
//
// Возвращаемое значение:
//   ТаблицаЗначений 
//
Функция Получить_СтоимостьИРасположениеЗаказовГруппыДоставки(таблицаЗаказов, ТочкаНазначения) 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тзСостав.Покупка КАК Покупка,
		|	тзСостав.Цена КАК Цена,
		|	тзСостав.КодЗаказа КАК КодЗаказа,
		|	тзСостав.Участник КАК Участник
		|ПОМЕСТИТЬ тзВнешн
		|ИЗ
		|	&тзСостав КАК тзСостав
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	тзВнешн.Покупка КАК Покупка,
		|	тзВнешн.Участник КАК Участник,
		|	тзВнешн.Цена КАК Цена,
		|	тзВнешн.КодЗаказа КАК КодЗаказа,
		|	ЗаказыВПосылкахОстатки.Посылка КАК Посылка
		|ПОМЕСТИТЬ заказыСпосылками
		|ИЗ
		|	тзВнешн КАК тзВнешн
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыВПосылках.Остатки(
		|				,
		|				(Покупка, Участник, КодЗаказа) В
		|					(ВЫБРАТЬ
		|						тзВнешн.Покупка КАК Покупка,
		|						тзВнешн.Участник КАК Участник,
		|						тзВнешн.КодЗаказа КАК КодЗаказа
		|					ИЗ
		|						тзВнешн КАК тзВнешн)) КАК ЗаказыВПосылкахОстатки
		|		ПО тзВнешн.Покупка = ЗаказыВПосылкахОстатки.Покупка
		|			И тзВнешн.Участник = ЗаказыВПосылкахОстатки.Участник
		|			И тзВнешн.КодЗаказа = ЗаказыВПосылкахОстатки.КодЗаказа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТранзитОстатки.ПокупкаСсылка КАК Покупка,
		|	ТранзитОстатки.Участник КАК Участник,
		|	ТранзитОстатки.МестоХранения КАК МестоХранения,
		|	ТранзитОстатки.Габарит КАК Габарит,
		|	ТранзитОстатки.Партия КАК Партия,
		|	ТранзитОстатки.КоличествоОстаток КАК Количество,
		|	ТранзитОстатки.Точка КАК Точка,
		|	ВЫБОР
		|		КОГДА ТранзитОстатки.Точка = &ТочкаНазначения
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ДругойПВ
		|ПОМЕСТИТЬ ПокупкиПосылкиСРасположением
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(
		|			,
		|			(ПокупкаСсылка, Участник) В
		|				(ВЫБРАТЬ
		|					заказыСпосылками.Посылка КАК Покупка,
		|					заказыСпосылками.Участник КАК Участник
		|				ИЗ
		|					заказыСпосылками КАК заказыСпосылками)) КАК ТранзитОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	заказыСпосылками.Покупка КАК Покупка,
		|	заказыСпосылками.Участник КАК Участник,
		|	заказыСпосылками.Цена КАК ОбъявленнаяСтоимость,
		|	заказыСпосылками.КодЗаказа КАК КодЗаказа,
		|	заказыСпосылками.Посылка КАК Посылка,
		|	ПокупкиПосылкиСРасположением.МестоХранения КАК МестоХранения,
		|	ПокупкиПосылкиСРасположением.Габарит КАК Габарит,
		|	ПокупкиПосылкиСРасположением.Партия КАК Партия,
		|	ПокупкиПосылкиСРасположением.Количество КАК Количество,
		|	ПокупкиПосылкиСРасположением.Точка КАК Точка,
		|	ПокупкиПосылкиСРасположением.ДругойПВ КАК ДругойПВ
		|ПОМЕСТИТЬ ОстаткиСКодомЗаказа
		|ИЗ
		|	заказыСпосылками КАК заказыСпосылками
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПокупкиПосылкиСРасположением КАК ПокупкиПосылкиСРасположением
		|		ПО заказыСпосылками.Посылка = ПокупкиПосылкиСРасположением.Покупка
		|			И заказыСпосылками.Участник = ПокупкиПосылкиСРасположением.Участник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиСКодомЗаказа.Покупка 		КАК Покупка,
		|	ОстаткиСКодомЗаказа.Участник 		КАК Участник,
		|	ОстаткиСКодомЗаказа.ОбъявленнаяСтоимость КАК ОбъявленнаяСтоимость,
		|	ОстаткиСКодомЗаказа.КодЗаказа 		КАК КодЗаказа,
		|	ОстаткиСКодомЗаказа.Посылка 		КАК Посылка,
		|	ОстаткиСКодомЗаказа.МестоХранения 	КАК МестоХранения,
		|	ОстаткиСКодомЗаказа.Габарит			КАК Габарит,
		|	ОстаткиСКодомЗаказа.Партия 			КАК Партия,
		|	ЕСТЬNULL(ОстаткиСКодомЗаказа.Количество, 0) КАК Количество,
		|	ОстаткиСКодомЗаказа.Точка 			КАК Точка,
		|	ЕСТЬNULL(ОстаткиСКодомЗаказа.ДругойПВ, ЛОЖЬ) КАК ДругойПВ,
		|	РАЗНОСТЬДАТ(ОстаткиСКодомЗаказа.Партия.Дата, &ТекущаяДата, ДЕНЬ) КАК ВремяХранения,
		
		|	ЕСТЬNULL(ДанныеЗаказов.Вес, 0) 						КАК Вес,
		|	ЕСТЬNULL(ДанныеЗаказов.объем, 0) 					КАК Объем,
		|	ЕСТЬNULL(ДанныеЗаказовСайт.БесплатнаяВыдача, Ложь) 	КАК БесплатнаяВыдача,
		|	ДанныеЗаказовСайт.ПерваяТочка 						КАК ПерваяТочка,
		|	ЕСТЬNULL(ДанныеЗаказовСайт.НадбавкаЗаОбработку, 0) 	КАК Надбавка,
		
		|	0     как СтоимостьДоставки,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаХранения, 0) КАК ЦенаХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.СрокХранения, 0) КАК СрокХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Заморозка, ЛОЖЬ) КАК Заморозка,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Штраф, 0) КАК Штраф,
		|	ЕСТЬNULL(ТарифыСрезПоследних.негабарит, ЛОЖЬ) КАК негабарит,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаЗаКГ, 0) КАК ЦенаЗаКГ,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаЗаКуб, 0) КАК ЦенаЗаКуб,
		|	ВЫБОР
		|		КОГДА ТарифыСрезПоследних.ЦенаХранения ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ТарифУстановлен

		|ИЗ
		|	ОстаткиСКодомЗаказа КАК ОстаткиСКодомЗаказа
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЗаказов КАК ДанныеЗаказов
		|		ПО ОстаткиСКодомЗаказа.Посылка = ДанныеЗаказов.Заказ
		|			И ОстаткиСКодомЗаказа.Партия = ДанныеЗаказов.Партия
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЗаказовСайт КАК ДанныеЗаказовСайт
		|		ПО ОстаткиСКодомЗаказа.Посылка = ДанныеЗаказовСайт.Заказ
		|			И ОстаткиСКодомЗаказа.Партия = ДанныеЗаказовСайт.Партия
		
		
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НегабаритЗначения КАК НегабаритЗначения
		//|		ПО ОстаткиСКодомЗаказа.Партия = НегабаритЗначения.Регистратор
		//|			И ОстаткиСКодомЗаказа.Посылка = НегабаритЗначения.Покупка
		//|			И ОстаткиСКодомЗаказа.Участник = НегабаритЗначения.Участник
		//|			И ОстаткиСКодомЗаказа.Габарит = НегабаритЗначения.Габарит
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних
		|		ПО ОстаткиСКодомЗаказа.Габарит = ТарифыСрезПоследних.Габарит";
		//|			И (НЕ ТарифыСрезПоследних.Отменен)
		
		
		
	Запрос.УстановитьПараметр("тзСостав", 			таблицаЗаказов);
	Запрос.УстановитьПараметр("ТочкаНазначения", 	ТочкаНазначения);
	Запрос.УстановитьПараметр("ТекущаяДата", 		ТекущаяДата());
	РезультатЗапроса = Запрос.Выполнить();
	тзРезультат = РезультатЗапроса.Выгрузить();
	СП_РаботаСДокументами.РасчитатьСтоимостьХранения(тзРезультат);
	
	Возврат тзРезультат;	
КонецФункции


// Получить места хранеия заказов для переданой ТаблицыЗаказов. 
// Если заказ в посылке ищется с учетом кода закказа
// если поступило покупкой то код заказа пустаяя строка
//
// Параметры:
//  таблицаЗаказов  - ТаблицаЗначений - 
//  ТочкаНазначения - СправочникСсылка.ТочкиРаздачи -
//
// Возвращаемое значение:
//   ТаблицаЗначений 
//
Функция Получить_СтоимостьИРасположениеОдиночныхЗаказов(таблицаЗаказов, ТочкаНазначения) 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тзСостав.Покупка 	КАК Покупка,
		|	тзСостав.Цена 		КАК Цена,
		|	тзСостав.Участник 	КАК Участник
		|ПОМЕСТИТЬ тзВнешн
		|ИЗ
		|	&тзСостав КАК тзСостав
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТранзитОстатки.ПокупкаСсылка 		КАК Покупка,
		|	ТранзитОстатки.Участник 			КАК Участник,
		|	ТранзитОстатки.МестоХранения 		КАК МестоХранения,
		|	ТранзитОстатки.Габарит 				КАК Габарит,
		|	ТранзитОстатки.Партия 				КАК Партия,
		|	ТранзитОстатки.КоличествоОстаток 	КАК Количество,
		|	ТранзитОстатки.Точка 				КАК Точка,
		|	ВЫБОР
		|		КОГДА ТранзитОстатки.Точка = &ТочкаНазначения
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ 								КАК ДругойПВ
		|ПОМЕСТИТЬ ПокупкиПосылкиСРасположением
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(, (ПокупкаСсылка, Участник) В
		|		(ВЫБРАТЬ
		|			тзВнешн.Покупка КАК Покупка,
		|			тзВнешн.Участник КАК Участник
		|		ИЗ
		|			тзВнешн КАК тзВнешн)) КАК ТранзитОстатки
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	тзВнешн.Покупка 					КАК Покупка,
		|	тзВнешн.Участник 					КАК Участник,
		|	тзВнешн.Цена 						КАК ОбъявленнаяСтоимость,
		|	ПокупкиПосылкиСРасположением.МестоХранения 	КАК МестоХранения,
		|	ПокупкиПосылкиСРасположением.Габарит 		КАК Габарит,
		|	ПокупкиПосылкиСРасположением.Партия 		КАК Партия,
		|	ПокупкиПосылкиСРасположением.Количество 	КАК Количество,
		|	ПокупкиПосылкиСРасположением.Точка 			КАК Точка,
		|	ПокупкиПосылкиСРасположением.ДругойПВ 		КАК ДругойПВ
		|ПОМЕСТИТЬ ОстаткиСКодомЗаказа
		|ИЗ
		|	тзВнешн КАК тзВнешн
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПокупкиПосылкиСРасположением КАК ПокупкиПосылкиСРасположением
		|		ПО тзВнешн.Покупка = ПокупкиПосылкиСРасположением.Покупка
		|		И тзВнешн.Участник = ПокупкиПосылкиСРасположением.Участник
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиСКодомЗаказа.Покупка КАК Покупка,
		|	ОстаткиСКодомЗаказа.Участник КАК Участник,
		|	ОстаткиСКодомЗаказа.ОбъявленнаяСтоимость КАК ОбъявленнаяСтоимость,
		|	ОстаткиСКодомЗаказа.МестоХранения КАК МестоХранения,
		|	ОстаткиСКодомЗаказа.Габарит КАК Габарит,
		|	ОстаткиСКодомЗаказа.Партия КАК Партия,
		|	ЕСТЬNULL(ОстаткиСКодомЗаказа.Количество, 0) КАК Количество,
		|	ОстаткиСКодомЗаказа.Точка КАК Точка,
		|	ЕСТЬNULL(ОстаткиСКодомЗаказа.ДругойПВ, ЛОЖЬ) КАК ДругойПВ,
		|	ЕСТЬNULL(ДанныеЗаказов.Вес, 0) 						КАК Вес,
		|	ЕСТЬNULL(ДанныеЗаказов.объем, 0) 					КАК Объем,
		|	РАЗНОСТЬДАТ(ОстаткиСКодомЗаказа.Партия.Дата, &ТекущаяДата, ДЕНЬ) КАК ВремяХранения,
		|	ложь  как БесплатнаяВыдача,
		|	0     как СтоимостьДоставки,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаХранения, 0) КАК ЦенаХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.СрокХранения, 0) КАК СрокХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Заморозка, ЛОЖЬ) КАК Заморозка,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Штраф, 0) КАК Штраф,
		|	ЕСТЬNULL(ТарифыСрезПоследних.негабарит, ЛОЖЬ) КАК негабарит,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаЗаКГ, 0) КАК ЦенаЗаКГ,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаЗаКуб, 0) КАК ЦенаЗаКуб,
		|	ВЫБОР
		|		КОГДА ТарифыСрезПоследних.ЦенаХранения ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ТарифУстановлен

		|ИЗ
		|	ОстаткиСКодомЗаказа КАК ОстаткиСКодомЗаказа  
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЗаказов КАК ДанныеЗаказов
		|		ПО ОстаткиСКодомЗаказа.Покупка = ДанныеЗаказов.Заказ
		|			И ОстаткиСКодомЗаказа.Партия = ДанныеЗаказов.Партия
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НегабаритЗначения КАК НегабаритЗначения
		//|		ПО ОстаткиСКодомЗаказа.Партия 	= НегабаритЗначения.Регистратор
		//|		И ОстаткиСКодомЗаказа.Покупка 	= НегабаритЗначения.Покупка.Покупка
		//|		И ОстаткиСКодомЗаказа.Участник 	= НегабаритЗначения.Участник
		//|		И ОстаткиСКодомЗаказа.Габарит 	= НегабаритЗначения.Габарит
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних
		|		ПО ОстаткиСКодомЗаказа.Габарит = ТарифыСрезПоследних.Габарит ";
		//|			И (НЕ ТарифыСрезПоследних.Отменен)
		
		
		
	Запрос.УстановитьПараметр("тзСостав", 			таблицаЗаказов);
	Запрос.УстановитьПараметр("ТочкаНазначения", 	ТочкаНазначения);
	Запрос.УстановитьПараметр("ТекущаяДата", 		ТекущаяДата());
	РезультатЗапроса = Запрос.Выполнить();
	тзРезультат = РезультатЗапроса.Выгрузить();
	СП_РаботаСДокументами.РасчитатьСтоимостьХранения(тзРезультат);
	
	Возврат тзРезультат;	
КонецФункции




#КонецОбласти

Функция ПолноеИмяОбъекта()
	Возврат "Документ.ОтправлениеТранзита";
КонецФункции
