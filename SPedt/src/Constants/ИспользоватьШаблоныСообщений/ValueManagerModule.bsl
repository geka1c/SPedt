#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение Тогда
		ДоступнаОтправкаSMS = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS");
		ДоступнаРаботаСПочтовымиСообщениями = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
	Иначе
		ДоступнаОтправкаSMS = Ложь;
		ДоступнаРаботаСПочтовымиСообщениями = Ложь;
	КонецЕсли;
	
	Константы.ИспользоватьОтправкуSMSВШаблонахСообщений.Установить(ДоступнаОтправкаSMS);
	Константы.ИспользоватьЭлектроннуюПочтуВШаблонахСообщений.Установить(ДоступнаРаботаСПочтовымиСообщениями);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
