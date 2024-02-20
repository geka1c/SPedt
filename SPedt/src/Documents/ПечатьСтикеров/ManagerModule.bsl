Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	идентификаторыПечатныхФорм		= 	новый массив();
	идентификаторыПечатныхФорм.Добавить("ПечатьСтикеровПосылки");
	идентификаторыПечатныхФорм.Добавить("ПечатьСтикеровКоробки");
	
    КомандаПечати 					= КомандыПечати.Добавить();
    КомандаПечати.МенеджерПечати 	= "Документ.ПечатьСтикеров";
    КомандаПечати.Идентификатор 	= "ПечатьСтикеровПосылки,ПечатьСтикеровКоробки";
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
        СтоСП_Печать.ТабДок_СтикерПосылки(МассивОбъектов, ОбъектыПечати),
        ,
        "ОбщиеМакеты.ПФ_MXL_ПосылкаЭтикетка");
		
	КонецЕсли;		
	
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьСтикеровКоробки");
    Если НужноПечататьМакет Тогда
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
        КоллекцияПечатныхФорм,
        "ПечатьСтикеровКоробки",
        НСтр("ru = 'Печать cтикеров (Коробки)'"),
        СтоСП_Печать.ТабДок_СтикерКоробки(МассивОбъектов, ОбъектыПечати),
        ,
        "ОбщиеМакеты.ПФ_MXL_КоробкаЭтикетка");
		
		
	КонецЕсли;			
	
#КонецЕсли 	
КонецПроцедуры



Функция ТабДок_СтикерыШтрихКодов(МассивОбъектов, ОбъектыПечати) Экспорт
	ТабДок= Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет("ПФ_MXL_СупперГруппаЭтикетка");
	Макет.АвтоМасштаб=Истина;


	Шапка 				= Макет.ПолучитьОбласть("Шапка");
	ТабДок.Очистить();

	
	
	ВставлятьРазделительСтраниц = Ложь;
	Для каждого Выборка из МассивОбъектов Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ШК							= Выборка.Супергруппа.Код;
		ОбластьШК					= Шапка.Области.Шапка;
		РисунокШтрихкод				= Шапка.Рисунки.РисунокШтрихкод;
		
		
		ПараметрыШтрихкода			= Документы.ВыдачаТранзита.ЗаполнитьПараметрыОбработки(ШК);
		РисунокШтрихкод.Картинка 	= МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
		РисунокШтрихкод.Расположить(ОбластьШК);
		помеченныеСтроки			= Выборка.Покупки.НайтиСтроки(Новый Структура("Подбор", Истина));
		Шапка.Параметры.Заполнить(Выборка);
		Шапка.Параметры.Описание = ""+Выборка.ТочкаНазначения + ", "+помеченныеСтроки.Количество() + " стикеров, "+ Выборка.Дата;
		ТабДок.Вывести(Шапка);
		
	
		

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ПолеСлева			= 0;
	ТабДок.ПолеСправа			= 0;
	ТабДок.ПолеСверху			= 0;
	ТабДок.ПолеСнизу			= 0;
	
	Возврат ТабДок;
КонецФункции


