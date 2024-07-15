#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура выполнитьОбмен(Команда)
	выполнитьОбменНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	Док = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.СинхронизацияСправочников"));
	док.ЗаполнитьПеродыЗагрузки();
	ЗначениеВДанныеФормы(док, объект);
КонецПроцедуры

&НаСервере
Процедура выполнитьОбменНаСервере()
	Док = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.СинхронизацияСправочников"));
	док.ЗагрузитьСправочники();
	ЗначениеВДанныеФормы(док, объект)
КонецПроцедуры

#КонецОбласти