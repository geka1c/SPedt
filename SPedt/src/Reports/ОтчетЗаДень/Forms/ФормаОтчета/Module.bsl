
&НаКлиенте
Процедура Сформировать(Команда)
	// Вставить содержимое обработчика.

    ДатаС=НачалоДня(ДатаС);
	ДатаПо=КонецДня(ДатаПо);
	ПечатьПриход(ТабДок, ДатаС, ДатаПо);

	Печать_Выдача(ТабДок, ДатаС, ДатаПо);
	
	Печать_БесплатнаяВыдача(ТабДок, ДатаС, ДатаПо);
	
	ПечатьТранзит(ТабДок, ДатаС, ДатаПо);
	ПечатьДоставкаКурьером(ТабДок, ДатаС, ДатаПо);
	
	ПечатьСписание(ТабДок, ДатаС, ДатаПо);
	ПечатьПродажи(ТабДок, ДатаС, ДатаПо);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура Печать_Выдача(ТабДок, ДатаС, ДатаПо)
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);
	
	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	вложенныйЗапрос.Габарит КАК Габарит,
		|	вложенныйЗапрос.Участник КАК Участник,
		|	вложенныйЗапрос.Покупка КАК Покупка,
		|	СУММА(вложенныйЗапрос.КоличествоОборот) КАК КоличествоОборот,
		|	СУММА(вложенныйЗапрос.СуммаОборот) КАК СуммаОборот,
		|	вложенныйЗапрос.ТипРасхода КАК ТипРасхода
		|ИЗ
		|	(ВЫБРАТЬ
		|		РасходОбороты.Габарит КАК Габарит,
		|		РасходОбороты.Участник КАК Участник,
		|		РасходОбороты.Покупка КАК Покупка,
		|		РасходОбороты.КоличествоОборот КАК КоличествоОборот,
		|		РасходОбороты.СуммаОборот КАК СуммаОборот,
		|		РасходОбороты.ТипРасхода КАК ТипРасхода
		|	ИЗ
		|		РегистрНакопления.Расход.Обороты(&ДатаБ, &ДатаЕ,,
		|		НЕ Списано
		|		И ТипРасхода <> &ТипРасхода) КАК РасходОбороты
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ЗНАЧЕНИЕ(Справочник.Габариты.ПустаяСсылка),
		|		ПродажиОбороты.Участник,
		|		ЗНАЧЕНИЕ(Справочник.Номенклатура.ПоискНикаУчастника),
		|		0,
		|		ПродажиОбороты.СтоимостьОборот,
		|		ЗНАЧЕНИЕ(Перечисление.ТипРасхода.Расход)
		|	ИЗ
		|		РегистрНакопления.Продажи.Обороты(&ДатаБ, &ДатаЕ, Регистратор,) КАК ПродажиОбороты
		|	ГДЕ
		|		ПродажиОбороты.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПоискНикаУчастника)) КАК вложенныйЗапрос
		|СГРУППИРОВАТЬ ПО
		|	вложенныйЗапрос.Габарит,
		|	вложенныйЗапрос.Участник,
		|	вложенныйЗапрос.Покупка,
		|	вложенныйЗапрос.ТипРасхода
		|УПОРЯДОЧИТЬ ПО
		|	вложенныйЗапрос.Габарит,
		|	вложенныйЗапрос.Покупка
		|ИТОГИ
		|	СУММА(КоличествоОборот),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ,
		|	Габарит";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
    Запрос.УстановитьПараметр("ТипРасхода", Перечисления.ТипРасхода.Транзит);

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьГабарит = Макет.ПолучитьОбласть("Габарит");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	//ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаГабарит = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаГабарит.Следующий() Цикл
		ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
		ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень(),,Ложь);

		ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
		КонецЦикла;
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
	
КонецПроцедуры // Печать()


&НаСервереБезКонтекста
Процедура Печать_БесплатнаяВыдача(ТабДок, ДатаС, ДатаПо)
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);
	
	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("МакетПредоплата");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходОбороты.Габарит КАК Габарит,
		|	РасходОбороты.Покупка КАК Покупка,
		|	РасходОбороты.Участник КАК Участник,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(РасходОбороты.Участник) = ТИП(Справочник.ТочкиРаздачи)
		|				И РасходОбороты.Участник.Код = ""0100""
		|			ТОГДА ""Доставка""
		|		КОГДА РасходОбороты.пристрой
		|				И РасходОбороты.ТипРасхода = ЗНАЧЕНИЕ(Перечисление.ТипРасхода.Транзит)
		|			ТОГДА ""Пристрой на транзит""
		|		ИНАЧЕ РасходОбороты.ТипРасхода
		|	КОНЕЦ КАК ТипРасхода,
		|	РасходОбороты.КоличествоОборот КАК Количество,
		|	РасходОбороты.ПредоплатаОборот КАК Сумма,
		|	РасходОбороты.Покупка.Организатор КАК Организатор,
		|	РасходОбороты.Регистратор КАК Регистратор,
		|	РасходОбороты.Регистратор.ВидОплаты КАК ВидОплаты,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(РасходОбороты.Участник) = ТИП(Справочник.ТочкиРаздачи)
		|				И РасходОбороты.Участник.Код = ""0100""
		|			ТОГДА ""Доставка""
		|		КОГДА ТИПЗНАЧЕНИЯ(РасходОбороты.Регистратор) = ТИП(Документ.Расходная)
		|				И НЕ РасходОбороты.Регистратор.Списать
		|			ТОГДА ""Услуги""
		|		ИНАЧЕ ""Товары""
		|	КОНЕЦ КАК ВидНоменклатуры,
		|	РасходОбороты.ПериодЧас КАК ПериодЧас,
		|	РасходОбороты.ПредоплаченоУчастником КАК ПредоплаченоУчастником
		|ИЗ
		|	РегистрНакопления.Расход.Обороты(&ДатаБ, &ДатаЕ, Авто, БесплатнаяВыдача) КАК РасходОбороты
		|ИТОГИ
		|	СУММА(Количество),
		|	СУММА(Сумма)
		|ПО
		|	ОБЩИЕ,
		|	ПредоплаченоУчастником,
		|	Габарит";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
    ;

	Результат = Запрос.Выполнить();

	ОбластьНазваниеОтчета	= Макет.ПолучитьОбласть("НазваниеОтчета");
	ОбластьПодвал 			= Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы 	= Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы 	= Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог 		= Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьГабарит 			= Макет.ПолучитьОбласть("Габарит");  
	ОбластьБВ 			    = Макет.ПолучитьОбласть("БВ");

	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	
	ОбластьНазваниеОтчета.Параметры.НазваниеОтчета = "Предоплата ";
	
	ТабДок.Вывести(ОбластьНазваниеОтчета);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());
	
	ВыборкаБВ = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаБВ.Следующий() Цикл   
		Если ВыборкаБВ.ПредоплаченоУчастником тогда
			ВидПредоплаты = "Предоплата участник";
		Иначе	
			ВидПредоплаты = "Предоплата организатор";
		КонецЕсли;	  
		ОбластьБВ.Параметры.ВидПредоплаты = ВидПредоплаты;     
		ОбластьБВ.Параметры.Заполнить(ВыборкаБВ);
		ТабДок.Вывести(ОбластьБВ, ВыборкаБВ.Уровень(),,Ложь);  
		ВыборкаГабарит = ВыборкаБВ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаГабарит.Следующий() Цикл
			ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
			ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень(),,Ложь);
			
			ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
				ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
			КонецЦикла;
		КонецЦикла;   
	КонецЦикла;


	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
	
КонецПроцедуры // Печать()


&НаСервереБезКонтекста
Процедура ПечатьСписание(ТабДок, ДатаС, ДатаПо)
     	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("МакетСписано");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходОбороты.Габарит КАК Габарит,
		|	ПРЕДСТАВЛЕНИЕ(РасходОбороты.Габарит),
		|	РасходОбороты.Участник,
		|	ПРЕДСТАВЛЕНИЕ(РасходОбороты.Участник),
		|	РасходОбороты.Покупка КАК Покупка,
	//	|	РасходОбороты.Покупка как ПокупкаСпр,
		|	СУММА(РасходОбороты.КоличествоОборот) КАК КоличествоОборот,
		|	СУММА(РасходОбороты.СуммаОборот) КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.Расход.Обороты(&ДатаБ, &ДатаЕ, , (Списано) И ТипРасхода <> &ТипРасхода) КАК РасходОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходОбороты.Габарит,
		|	РасходОбороты.Участник,
		|	РасходОбороты.Покупка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Габарит,
		|	Покупка
		|ИТОГИ
		|	СУММА(КоличествоОборот),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ,
		|	Габарит";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
    Запрос.УстановитьПараметр("ТипРасхода", Перечисления.ТипРасхода.Транзит);
	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьГабарит = Макет.ПолучитьОбласть("Габарит");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	//ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаГабарит = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаГабарит.Следующий() Цикл
		ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
		ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень(),,ложь);

		ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
		КонецЦикла;
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	
	
КонецПроцедуры // Печать()



&НаСервереБезКонтекста
Процедура ПечатьТранзит(ТабДок, ДатаС, ДатаПо)
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);
	
	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("МакетТранзит");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходОбороты.Габарит КАК Габарит,
		|	ПРЕДСТАВЛЕНИЕ(РасходОбороты.Габарит),
		|	РасходОбороты.Участник,
		|	ПРЕДСТАВЛЕНИЕ(РасходОбороты.Участник),
		|	РасходОбороты.Покупка КАК Покупка,
	//	|	РасходОбороты.Покупка как ПокупкаСпр,
		|	СУММА(ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(РасходОбороты.Покупка) = ТИП(Справочник.Коробки)
		|				ТОГДА РасходОбороты.Покупка.Количество
		|			ИНАЧЕ РасходОбороты.КоличествоОборот
		|		КОНЕЦ) КАК КоличествоОборот,
		|	СУММА(РасходОбороты.СуммаОборот) КАК СуммаОборот,
		|	РасходОбороты.ТипРасхода
		|ИЗ
		|	РегистрНакопления.Расход.Обороты(&ДатаБ, &ДатаЕ, , ТипРасхода = &ТипРасхода И Участник <> &Курьер) КАК РасходОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходОбороты.Габарит,
		|	РасходОбороты.Участник,
		|	РасходОбороты.Покупка,
		|	РасходОбороты.ТипРасхода
		|
		|УПОРЯДОЧИТЬ ПО
		|	Габарит,
		|	Покупка
		|ИТОГИ
		|	СУММА(КоличествоОборот),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ,
		|	Габарит";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
	Запрос.УстановитьПараметр("ТипРасхода", Перечисления.ТипРасхода.Транзит);
	Запрос.УстановитьПараметр("Курьер", 	Константы.ПунктВыдачиКурьерскойДоставки.Получить());

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьГабарит = Макет.ПолучитьОбласть("Габарит");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	//ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаГабарит = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаГабарит.Следующий() Цикл
		ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
		ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень(),,ложь);

		ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
		КонецЦикла;
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
КонецПроцедуры // Печать()





&НаСервереБезКонтекста
Процедура ПечатьДоставкаКурьером(ТабДок, ДатаС, ДатаПо)
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);
	
	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("МакетТранзит");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходОбороты.Габарит КАК Габарит,
		|	ПРЕДСТАВЛЕНИЕ(РасходОбороты.Габарит),
		|	РасходОбороты.Участник,
		|	ПРЕДСТАВЛЕНИЕ(РасходОбороты.Участник),
		|	РасходОбороты.Покупка КАК Покупка,
		|	СУММА(ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(РасходОбороты.Покупка) = ТИП(Справочник.Коробки)
		|			ТОГДА РасходОбороты.Покупка.Количество
		|		ИНАЧЕ РасходОбороты.КоличествоОборот
		|	КОНЕЦ) КАК КоличествоОборот,
		|	СУММА(РасходОбороты.СуммаОборот) КАК СуммаОборот,
		|	РасходОбороты.ТипРасхода
		|ИЗ
		|	РегистрНакопления.Расход.Обороты(&ДатаБ, &ДатаЕ,, ТипРасхода = &ТипРасхода
		|	И Участник = &Курьер) КАК РасходОбороты
		|СГРУППИРОВАТЬ ПО
		|	РасходОбороты.Габарит,
		|	РасходОбороты.Участник,
		|	РасходОбороты.Покупка,
		|	РасходОбороты.ТипРасхода
		|УПОРЯДОЧИТЬ ПО
		|	Габарит,
		|	Покупка
		|ИТОГИ
		|	СУММА(КоличествоОборот),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ,
		|	Габарит";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
	Запрос.УстановитьПараметр("ТипРасхода", Перечисления.ТипРасхода.Транзит);
	Запрос.УстановитьПараметр("Курьер", 	Константы.ПунктВыдачиКурьерскойДоставки.Получить());


	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокКурьерскаяДоставка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьГабарит = Макет.ПолучитьОбласть("Габарит");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	//ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаГабарит = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаГабарит.Следующий() Цикл
		ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
		ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень(),,ложь);

		ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
		КонецЦикла;
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
КонецПроцедуры // Печать()





&НаСервереБезКонтекста
Процедура ПечатьПриход(ТабДок, ДатаС, ДатаПо)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);

	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("Макет1");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КоробкиСостав.Ссылка,
		|	СУММА(1) КАК Количество
		|ПОМЕСТИТЬ КоробкаКоличество
		|ИЗ
		|	Справочник.Коробки.Состав КАК КоробкиСостав
		|
		|СГРУППИРОВАТЬ ПО
		|	КоробкиСостав.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриходОбороты.Габарит КАК Габарит,
		|	ПриходОбороты.Организатор,
		|	ПриходОбороты.Покупка,
//		|	ПриходОбороты.ПокупкаСпр,
		|	СУММА(ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(ПриходОбороты.Покупка) = ТИП(Справочник.Коробки)
		|				ТОГДА ЕСТЬNULL(КоробкаКоличество.Количество, ПриходОбороты.Покупка.Количество)
		|			ИНАЧЕ ПриходОбороты.КоличествоОборот
		|		КОНЕЦ) КАК КоличествоОборот
		|ИЗ
		|	РегистрНакопления.Приход.Обороты(&ДатаБ, &ДатаЕ, , ) КАК ПриходОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ КоробкаКоличество КАК КоробкаКоличество
		|		ПО ПриходОбороты.Покупка = КоробкаКоличество.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходОбороты.Габарит,
		|	ПриходОбороты.Организатор,
		|	ПриходОбороты.Покупка
//		|	ПриходОбороты.ПокупкаСпр
		|ИТОГИ
		|	СУММА(КоличествоОборот)
		|ПО
		|	ОБЩИЕ,
		|	Габарит";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьГабарит = Макет.ПолучитьОбласть("Габарит");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	ОбластьЗаголовок.Параметры.ДатаПо=Формат(ДатаПо,"ДЛФ=DD");
	ОбластьЗаголовок.Параметры.Дата=Формат(ДатаС,"ДЛФ=DD");
	ТабДок.Вывести(ОбластьЗаголовок);          
	ТабДок.Вывести(ОбластьШапкаТаблицы);
   	ТабДок.НачатьАвтогруппировкуСтрок();

	
	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаГабарит = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаГабарит.Следующий() Цикл
		ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
		ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень(),,ложь);

		ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
		КонецЦикла;
	КонецЦикла;
   	ТабДок.ЗакончитьАвтогруппировкуСтрок();

	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА



КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПечатьПродажи(ТабДок, ДатаС, ДатаПо)
    ДатаБ=НачалоДня(ДатаС);
	ДатаЕ=КонецДня(ДатаПо);
	
	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("МакетПродажи");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажиОбороты.Участник,
		|	ПРЕДСТАВЛЕНИЕ(ПродажиОбороты.Участник),
		|	СУММА(ПродажиОбороты.количествоОборот) КАК КоличествоОборот,
		|	ПродажиОбороты.СтоимостьОборот КАК СуммаОборот,
		|	ПродажиОбороты.Номенклатура,
		|	ТИПЗНАЧЕНИЯ(ПродажиОбороты.Номенклатура) КАК ВидТовара
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(&ДатаБ, &ДатаЕ, , ) КАК ПродажиОбороты
		|ГДЕ
		|	ПродажиОбороты.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПоискНикаУчастника)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПродажиОбороты.Участник,
		|	ПродажиОбороты.СтоимостьОборот,
		|	ПродажиОбороты.Номенклатура,
		|	ТИПЗНАЧЕНИЯ(ПродажиОбороты.Номенклатура)
		|ИТОГИ
		|	СУММА(КоличествоОборот),
		|	СУММА(СтоимостьОборот)
		|ПО
		|	ОБЩИЕ,
		|	ВидТовара";

	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);


	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьВидТовара = Макет.ПолучитьОбласть("ВидТовара");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	//ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаВидТовара = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаВидТовара.Следующий() Цикл
		ОбластьВидТовара.Параметры.Заполнить(ВыборкаВидТовара);
		ТабДок.Вывести(ОбластьВидТовара, ВыборкаВидТовара.Уровень(),,ложь);

		ВыборкаДетальныеЗаписи = ВыборкаВидТовара.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
		КонецЦикла;
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
КонецПроцедуры // Печать()




&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДатаС=НачалоДня(ТекущаяДата());
	ДатаПО=КонецДня(ТекущаяДата());
	//Вставить содержимое обработчика
КонецПроцедуры


