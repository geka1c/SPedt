
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Чек)
	ТабДок = Новый ТабличныйДокумент;
	Чек(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	//ТабДок.Напечатать();
	ТабДок.Показать();
	//}}
КонецПроцедуры

&НаСервере
Процедура Чек(ТабДок, ПараметрКоманды)
	Документы.Движение.Чек(ТабДок, ПараметрКоманды);
КонецПроцедуры
