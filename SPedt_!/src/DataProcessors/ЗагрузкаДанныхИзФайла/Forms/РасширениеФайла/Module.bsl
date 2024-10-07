#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если ТипСохраняемогоФайла = 0 Тогда 
		Результат = "xlsx";
	ИначеЕсли ТипСохраняемогоФайла = 1 Тогда
		Результат = "csv";
	ИначеЕсли ТипСохраняемогоФайла = 4 Тогда
		Результат = "xls";
	ИначеЕсли ТипСохраняемогоФайла = 5 Тогда
		Результат = "ods";
	Иначе
		Результат = "mxl";
	КонецЕсли;
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДополнениеДляОблегченияРаботыСФайлами(Команда)
	НачатьУстановкуРасширенияРаботыСФайлами(Неопределено);
КонецПроцедуры

#КонецОбласти








