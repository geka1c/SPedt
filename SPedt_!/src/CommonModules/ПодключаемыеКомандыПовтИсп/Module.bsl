#Область СлужебныеПроцедурыИФункции

Функция КэшФормы(Знач ИмяФормы, Знач ИсточникиЧерезЗапятую, Знач ЭтоФормаОбъекта) Экспорт
	Возврат Новый ФиксированнаяСтруктура(ПодключаемыеКоманды.КэшФормы(ИмяФормы, ИсточникиЧерезЗапятую, ЭтоФормаОбъекта));
КонецФункции

Функция Параметры() Экспорт
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы("СтандартныеПодсистемы.ПодключаемыеКоманды");
	Если Параметры = Неопределено Тогда
		ПодключаемыеКоманды.ОперативноеОбновлениеОбщихДанныхКонфигурации();
		Параметры = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы("СтандартныеПодсистемы.ПодключаемыеКоманды");
		Если Параметры = Неопределено Тогда
			Возврат Новый ФиксированнаяСтруктура("ПодключенныеОбъекты", Новый Соответствие);
		КонецЕсли;
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(ПараметрыСеанса.ВерсияРасширений) Тогда
	//	ПараметрыРасширений = СтандартныеПодсистемыСервер.ПараметрРаботыРасширения(ПодключаемыеКоманды.ПолноеИмяПодсистемы());
	//	Если ПараметрыРасширений = Неопределено Тогда
	//		ПодключаемыеКоманды.ПриЗаполненииВсехПараметровРаботыРасширений();
	//		ПараметрыРасширений = СтандартныеПодсистемыСервер.ПараметрРаботыРасширения(ПодключаемыеКоманды.ПолноеИмяПодсистемы());
	//		Если ПараметрыРасширений = Неопределено Тогда
	//			Возврат Новый ФиксированнаяСтруктура(Параметры);
	//		КонецЕсли;
	//	КонецЕсли;
	//	ДополнитьСоответствиеСМассивами(Параметры.ПодключенныеОбъекты, ПараметрыРасширений.ПодключенныеОбъекты);
	//КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
	Возврат Новый ФиксированнаяСтруктура(Параметры);
КонецФункции

Процедура ДополнитьСоответствиеСМассивами(СоответствиеПриемник, СоответствиеИсточник)
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		МассивПриемника = СоответствиеПриемник[КлючИЗначение.Ключ];
		Если МассивПриемника = Неопределено Тогда
			СоответствиеПриемник.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		Иначе
			Для Каждого Значение Из КлючИЗначение.Значение Цикл
				Если МассивПриемника.Найти(Значение) = Неопределено Тогда
					МассивПриемника.Добавить(Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
