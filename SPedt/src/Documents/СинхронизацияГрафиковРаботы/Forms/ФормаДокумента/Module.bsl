&НаКлиенте
Процедура ПросмотрПолученногоXML(Команда)
	хмл_incomes = Элементы.Протокол.ТекущиеДанные.ПолученныеДанные;
	СтоСП_Клиент.Показать_XML(хмл_incomes);
КонецПроцедуры


&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.Страницы.ТекущаяСтраница	= Элементы.Страницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок				= Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение		= Объект.Ссылка;
		парамДок.Использование	= Истина;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры


&НаСервере
Процедура ЗагрузитьРежимРаботыНаСервере()
	СтоСПОбмен_ГрафикРаботы.ЗагрузитьРежимРаботы(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРежимРаботы(Команда)
	ЗаписатьДокумент();
	ЗагрузитьРежимРаботыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПраздникиНаСервере()                   
	Объект.Праздники.Очистить();
	СтоСПОбмен_ГрафикРаботы.ЗагрузитьПраздничныеДни(Объект,НачалоГода(Объект.Дата));
	СтоСПОбмен_ГрафикРаботы.ЗагрузитьПраздничныеДни(Объект,КонецГода(Объект.Дата)+1);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПраздники(Команда)
	ЗаписатьДокумент();
	ЗагрузитьПраздникиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не ЗначениеЗаполнено(Объект.НачалоЗагрузки) Тогда
		Объект.НачалоЗагрузки	= НачалоМесяца(ТекущаяДата());
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьДокумент()
	Если не ЗначениеЗаполнено(Объект.Ссылка) или Модифицированность Тогда 
		СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтаФорма);	
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ДобавитьНеРабочиеДниНаСервере()
	СтоСПОбмен_ГрафикРаботы.ДобавитьНеРабочиеДни(Объект.ДобавитьНеРабочиеДни.Выгрузить(),Объект);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНеРабочиеДни(Команда)
	ЗаписатьДокумент();
	ДобавитьНеРабочиеДниНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКалендариНаСервере()
	ГрафикиРаботыПунктаВыдачи.ЗаполнитьКалендари(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКалендари(Команда)
	ЗаполнитьКалендариНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтразитьСинхранизациюВКалендаряхНаСервере()
	ГрафикиРаботыПунктаВыдачи.ПерезаполнитьКлендариДаннымиСинхронизации(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьСинхранизациюВКалендарях(Команда)
	ОтразитьСинхранизациюВКалендаряхНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтразитьПраздникиВСправочникНаСервере()
	ГрафикиРаботыПунктаВыдачи.ОтразитьПраздникиВСправочнике(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьПраздникиВСправочник(Команда)
	ОтразитьПраздникиВСправочникНаСервере();
КонецПроцедуры
