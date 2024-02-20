
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДокументПоступления	 =  Параметры.ДокументПоступления;
	Посылка				 =  Параметры.Посылка;
	
	Если ТипЗнч(Параметры.Посылка) = Тип("СправочникСсылка.Коробки") Тогда
		ПунктВыдачиПосылки	 = Параметры.Посылка.ТочкаНазначения;
	Иначе	
		ПунктВыдачиПосылки	 = Параметры.Посылка.ПунктВыдачи;
	КонецЕсли;
	ПунктВыдачиНаСтикере = Параметры.ПунктВыдачиНаСтикере;
	СвойПунктВыдачи		 = Константы.СвояТочка.Получить();
	
КонецПроцедуры

Процедура УстановитьВидимость()
	
	Элементы.Исправить.Видимость = (ЗначениеЗаполнено(ВыбранныйПунктВыдачи))
	
КонецПроцедуры	

&НаКлиенте
Процедура ВыбратьПВПосылки(Команда)
	ВыбранныйПунктВыдачи = ПунктВыдачиПосылки;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПВнастикере(Команда)
	ВыбранныйПунктВыдачи = ПунктВыдачиНаСтикере;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСвойПВ(Команда)
	ВыбранныйПунктВыдачи = СвойПунктВыдачи;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура Исправить(Команда)
	Закрыть(ВыбранныйПунктВыдачи);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДругойПВ(Команда)
	ВыбранныйПунктВыдачи = ДругойПунктВыдачи;
	УстановитьВидимость();
КонецПроцедуры
