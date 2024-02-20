#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ЕстьФайлыВТомах() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Файлы в томах отсутствуют.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ВыборПутиКАрхивуФайловТомов", , ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЕстьФайлыВТомах()
	
	Возврат РаботаСФайламиСлужебный.ЕстьФайлыВТомах();
	
КонецФункции

#КонецОбласти
