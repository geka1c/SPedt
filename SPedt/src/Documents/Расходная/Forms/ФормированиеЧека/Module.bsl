
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Печать = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоSMSПриИзменении(Элемент)
	
	Элементы.ПокупательНомер.Доступность = ПоSMS;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоEMailПриИзменении(Элемент)
	
	Элементы.ПокупательПочта.Доступность = ПоEMail;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПродолжить(Команда)
	
	Если Не Печать И Не ПоSMS И НЕ ПоEMail Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не выбран способ предоставление чека.'"));
	Иначе
		РезультатВыполнения = Новый Структура();
		РезультатВыполнения.Вставить("Печать", Печать);
		Если ПоEMail Тогда 
			РезультатВыполнения.Вставить("ПокупательEmail", ПокупательПочта);
		КонецЕсли;
		Если ПоSMS Тогда 
			РезультатВыполнения.Вставить("ПокупательНомер", ПокупательНомер);
		КонецЕсли;
		Закрыть(РезультатВыполнения); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияОтмена(Команда)
	
	Закрыть(Неопределено); 
	
КонецПроцедуры
