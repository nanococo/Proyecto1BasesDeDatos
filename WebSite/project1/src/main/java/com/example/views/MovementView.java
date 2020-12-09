package com.example.views;

import com.example.pojos.Movement;
import com.example.services.Services;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

@Route(value = "movement")
@CssImport("./styles/shared-styles.css")
public class MovementView extends VerticalLayout {

    private final Grid<Movement> dataGrid = new Grid<>(Movement.class);

    private final Services services;

    private final TextField filter = new TextField("Filter");
    private final Button filterBtn = new Button("Go");

//    private final Button viewMovements = new Button("Movimientos");

    public MovementView(@Autowired Services services) {
        this.services = services;

        H1 h1 = new H1("Movimientos del Estado de Cuenta");
        HorizontalLayout horizontalLayout = new HorizontalLayout(filter, filterBtn);
        horizontalLayout.setAlignItems(Alignment.BASELINE);

        configureDataGrid();
        configureFilterBtn();


        setSizeFull();
        add(h1, horizontalLayout, dataGrid);
    }

    private void configureFilterBtn() {
        filterBtn.addClickListener(buttonClickEvent -> {
           if(filter.getValue().equals("")){
               dataGrid.setItems(services.getMovements());
           }else{
               dataGrid.setItems(services.filterMovements(filter.getValue()));
           }
        });
    }


    private void configureDataGrid() {
        dataGrid.setItems(services.getMovements());
        dataGrid.setSizeFull();
        dataGrid.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGrid.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGrid.setVerticalScrollingEnabled(true);
        //dataGrid.setColumnOrder(dataGrid.getColumnByKey("statementId"), dataGrid.getColumnByKey("accountId"), dataGrid.getColumnByKey("initialBalance"), dataGrid.getColumnByKey("endBalance"), dataGrid.getColumnByKey("startDate"), dataGrid.getColumnByKey("endDate"));
        dataGrid.getColumns().forEach(col -> col.setAutoWidth(true));
        dataGrid.asSingleSelect().addValueChangeListener(event -> {
//            Common.startDate = event.getValue().getStartDate();
//            Common.endDate = event.getValue().getEndDate();
//            viewMovements.setEnabled(true);
        });
    }
}
