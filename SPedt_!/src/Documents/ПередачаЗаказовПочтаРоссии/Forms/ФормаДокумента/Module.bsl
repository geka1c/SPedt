
&НаСервере
Процедура ЗаполнитьНаСервере()
	док = РеквизитФормыВЗначение("Объект");
	Док.ЗаполнитьЗаказы();
	ЗначениеВРеквизитФормы(Док,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры
