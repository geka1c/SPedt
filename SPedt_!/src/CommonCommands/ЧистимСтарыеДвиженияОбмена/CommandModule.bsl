
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбработкаКомандыНаСервере();
КонецПроцедуры


Процедура ОбработкаКомандыНаСервере()
	парам=Новый Массив();
	парам.Добавить(НачалоМесяца(ДобавитьМесяц(ТекущаяДата(),-1)));

	ФоновыеЗадания.Выполнить("СтоСПОбмен_Общий.ЧистимСтарыеДвиженияОбмена",парам,1,"ЧистимСтарыеДвиженияОбмена");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Задание запущено");
//	СтоСПОбмен_Общий.ЧистимСтарыеДвиженияОбмена(НачалоМесяца(ДобавитьМесяц(ТекущаяДата(),-1)));
КонецПроцедуры
