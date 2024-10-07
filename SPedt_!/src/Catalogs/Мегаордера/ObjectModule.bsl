

Процедура ПередЗаписью(Отказ)
	Если не ЗначениеЗаполнено(типМегаордера) И ЗначениеЗаполнено(Покупка) Тогда 
		Если ТипЗнч(Покупка) = Тип("СправочникСсылка.Коробки")  Тогда
			Коробка = Покупка;
			Если Покупка.ВидСтикера = Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
				типМегаордера = Перечисления.типМегаордера.ГруппаДоставки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если  	типМегаордера 	= 	Перечисления.типМегаордера.Посылка и
			Посылка 		<>  Покупка Тогда
			
		    Участник	= Посылка.Участник;
			Покупка		= Посылка;
	ИначеЕсли  	типМегаордера 	= 	Перечисления.типМегаордера.Коробка и
			Коробка		 		<>  Покупка Тогда
			Покупка = Коробка;
	КонецЕсли;
КонецПроцедуры

