# ============================================================================
# PROYECTO OLAP - Generador de Graficos Python
# ============================================================================
# Descripcion: Genera graficos PNG y dashboard HTML desde las vistas OLAP
# Hechos cubiertos:
#   (a) Producto por proveedor, tiempo y ubicacion
#   (b) Modalidad de pago por tiempo y region
#   (e) Producto mas vendido por categoria, tiempo, ubicacion y pago
# ============================================================================
# Requisitos: Python 3.x, pandas, matplotlib, seaborn, pyodbc
# Uso: python OLAP_Graficos.py
# Salida: ./graficos/*.png y ./graficos/dashboard.html
# ============================================================================

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pyodbc
from datetime import datetime

# ============================================================================
# CONFIGURACION DE CONEXION - EDITAR ANTES DE EJECUTAR
# ============================================================================
CONN_STR = (
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server=[tu-servidor].database.windows.net;"
    "Database=[nombre-base-datos];"
    "Uid=usuario_olap;"
    "Pwd=OlapSecure2025!;"
    "Encrypt=yes;TrustServerCertificate=no;"
)

# =============================================================================
# CONSULTAS OLAP - Cubren los 3 hechos seleccionados del enunciado
# =============================================================================
QUERIES = {
    # Hecho A: Producto mas vendido por proveedor, tiempo y ubicacion
    "a_producto_proveedor_tiempo_ubicacion": """
        SELECT 
            dp.Nombre AS Producto,
            dprov.Nombre AS Proveedor,
            dt.Anio,
            dt.Trimestre,
            dt.NombreMes AS Mes,
            u.Ciudad AS UbicacionCliente,
            SUM(f.Cantidad) AS UnidadesVendidas,
            SUM(f.MontoTotal) AS MontoTotal
        FROM dbo.FactVentas f
        JOIN dbo.DimProducto dp ON dp.ProductoKey = f.ProductoKey
        JOIN dbo.DimProveedor dprov ON dprov.ProveedorKey = f.ProveedorKey
        JOIN dbo.DimTiempo dt ON dt.TiempoKey = f.TiempoKey
        JOIN dbo.DimUbicacion u ON u.UbicacionKey = f.UbicacionClienteKey
        GROUP BY dp.Nombre, dprov.Nombre, dt.Anio, dt.Trimestre, dt.NombreMes, u.Ciudad
    """,
    
    # Hecho A: Top 10 productos por proveedor
    "a_top_productos_proveedor": """
        SELECT TOP 10
            dp.Nombre AS Producto,
            dprov.Nombre AS Proveedor,
            SUM(f.Cantidad) AS UnidadesVendidas,
            SUM(f.MontoTotal) AS MontoTotal
        FROM dbo.FactVentas f
        JOIN dbo.DimProducto dp ON dp.ProductoKey = f.ProductoKey
        JOIN dbo.DimProveedor dprov ON dprov.ProveedorKey = f.ProveedorKey
        GROUP BY dp.Nombre, dprov.Nombre
        ORDER BY UnidadesVendidas DESC
    """,
    
    # Hecho B: Forma de pago preferida por tiempo y region
    "b_pago_tiempo_region": """
        SELECT 
            dmod.Descripcion AS ModalidadPago,
            dmod.Cuotas,
            dt.Anio,
            dt.Trimestre,
            u.Pais,
            u.Ciudad,
            COUNT(DISTINCT f.FactVentaID) AS NumeroTransacciones,
            SUM(f.MontoTotal) AS MontoTotal
        FROM dbo.FactVentas f
        JOIN dbo.DimModalidadPago dmod ON dmod.ModalidadKey = f.ModalidadKey
        JOIN dbo.DimTiempo dt ON dt.TiempoKey = f.TiempoKey
        JOIN dbo.DimUbicacion u ON u.UbicacionKey = f.UbicacionClienteKey
        GROUP BY dmod.Descripcion, dmod.Cuotas, dt.Anio, dt.Trimestre, u.Pais, u.Ciudad
    """,
    
    # Hecho B: Top formas de pago por ciudad
    "b_top_pago_ciudad": """
        SELECT TOP 15
            dmod.Descripcion + CASE WHEN dmod.Cuotas > 0 THEN ' (' + CAST(dmod.Cuotas AS VARCHAR) + ' cuotas)' ELSE '' END AS ModalidadPago,
            u.Ciudad,
            SUM(f.MontoTotal) AS MontoTotal,
            COUNT(*) AS NumTransacciones
        FROM dbo.FactVentas f
        JOIN dbo.DimModalidadPago dmod ON dmod.ModalidadKey = f.ModalidadKey
        JOIN dbo.DimUbicacion u ON u.UbicacionKey = f.UbicacionClienteKey
        GROUP BY dmod.Descripcion, dmod.Cuotas, u.Ciudad
        ORDER BY MontoTotal DESC
    """,
    
    # Hecho E: Mejor vendedor por categoria, tiempo, ubicacion y modalidad
    "e_vendedor_categoria_tiempo_ubicacion_modalidad": """
        SELECT 
            demp.Nombre AS Vendedor,
            dcat.Nombre AS Categoria,
            dt.Anio,
            dt.Trimestre,
            u.Ciudad,
            dmod.Descripcion AS ModalidadPago,
            SUM(f.Cantidad) AS UnidadesVendidas,
            SUM(f.MontoTotal) AS MontoTotal,
            SUM(f.MontoIVA) AS IVARecaudado
        FROM dbo.FactVentas f
        JOIN dbo.DimEmpleado demp ON demp.EmpleadoKey = f.EmpleadoKey
        JOIN dbo.DimCategoria dcat ON dcat.CategoriaKey = f.CategoriaKey
        JOIN dbo.DimTiempo dt ON dt.TiempoKey = f.TiempoKey
        JOIN dbo.DimUbicacion u ON u.UbicacionKey = f.UbicacionClienteKey
        JOIN dbo.DimModalidadPago dmod ON dmod.ModalidadKey = f.ModalidadKey
        GROUP BY demp.Nombre, dcat.Nombre, dt.Anio, dt.Trimestre, u.Ciudad, dmod.Descripcion
    """,
    
    # Hecho E: Top vendedores general
    "e_top_vendedores": """
        SELECT TOP 10
            demp.Nombre AS Vendedor,
            SUM(f.Cantidad) AS UnidadesVendidas,
            SUM(f.MontoTotal) AS MontoTotal,
            COUNT(DISTINCT dcat.CategoriaKey) AS CategoriasAtendidas
        FROM dbo.FactVentas f
        JOIN dbo.DimEmpleado demp ON demp.EmpleadoKey = f.EmpleadoKey
        JOIN dbo.DimCategoria dcat ON dcat.CategoriaKey = f.CategoriaKey
        GROUP BY demp.Nombre
        ORDER BY MontoTotal DESC
    """,
    
    # Resumen general para dashboard
    "resumen_general": """
        SELECT 
            dt.Anio,
            COUNT(DISTINCT f.FactVentaID) AS TotalTransacciones,
            SUM(f.Cantidad) AS TotalUnidades,
            SUM(f.MontoSubtotal) AS TotalSubtotal,
            SUM(f.MontoIVA) AS TotalIVA,
            SUM(f.MontoTotal) AS TotalVentas
        FROM dbo.FactVentas f
        JOIN dbo.DimTiempo dt ON dt.TiempoKey = f.TiempoKey
        GROUP BY dt.Anio
        ORDER BY dt.Anio
    """,
    
    # Productos con IVA vs sin IVA
    "analisis_iva": """
        SELECT 
            CASE WHEN dp.PorcentajeIVA = 15 THEN 'IVA 15%' ELSE 'IVA 0%' END AS TipoIVA,
            COUNT(*) AS NumeroProductos,
            SUM(f.Cantidad) AS UnidadesVendidas,
            SUM(f.MontoSubtotal) AS Subtotal,
            SUM(f.MontoIVA) AS IVARecaudado,
            SUM(f.MontoTotal) AS Total
        FROM dbo.FactVentas f
        JOIN dbo.DimProducto dp ON dp.ProductoKey = f.ProductoKey
        GROUP BY CASE WHEN dp.PorcentajeIVA = 15 THEN 'IVA 15%' ELSE 'IVA 0%' END
    """
}


def connect_database():
    """Establece conexion con la base de datos."""
    try:
        conn = pyodbc.connect(CONN_STR)
        print("Conexion exitosa a la base de datos.")
        return conn
    except pyodbc.Error as e:
        print(f"Error de conexion: {e}")
        print("\nAsegurate de:")
        print("1. Editar CONN_STR con tus credenciales")
        print("2. Tener instalado ODBC Driver 18 for SQL Server")
        print("3. Verificar que el firewall permita la conexion")
        return None


def fetch_dataframe(conn, name, sql):
    """Ejecuta una consulta y retorna un DataFrame."""
    try:
        df = pd.read_sql(sql, conn)
        print(f"  - {name}: {len(df)} registros")
        return df
    except Exception as e:
        print(f"  - Error en {name}: {e}")
        return pd.DataFrame()


def setup_style():
    """Configura el estilo de los graficos."""
    plt.style.use('seaborn-v0_8-whitegrid')
    sns.set_palette("husl")
    plt.rcParams['figure.figsize'] = (12, 6)
    plt.rcParams['font.size'] = 10
    plt.rcParams['axes.titlesize'] = 14
    plt.rcParams['axes.labelsize'] = 12


def crear_grafico_barras_horizontal(df, x, y, titulo, archivo, color='#2d6cdf'):
    """Crea un grafico de barras horizontal."""
    fig, ax = plt.subplots(figsize=(12, 8))
    bars = ax.barh(df[x].astype(str), df[y], color=color)
    ax.set_xlabel(y)
    ax.set_ylabel(x)
    ax.set_title(titulo, fontweight='bold', pad=20)
    ax.invert_yaxis()
    
    # Agregar valores en las barras
    for bar, val in zip(bars, df[y]):
        ax.text(bar.get_width() + max(df[y]) * 0.01, bar.get_y() + bar.get_height()/2, 
                f'{val:,.0f}', va='center', fontsize=9)
    
    plt.tight_layout()
    plt.savefig(archivo, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"    Guardado: {archivo}")


def crear_grafico_lineas(df, x, y, titulo, archivo, hue=None):
    """Crea un grafico de lineas para tendencias temporales."""
    fig, ax = plt.subplots(figsize=(12, 6))
    
    if hue and hue in df.columns:
        for grupo in df[hue].unique():
            data = df[df[hue] == grupo]
            ax.plot(data[x], data[y], marker='o', label=grupo, linewidth=2)
        ax.legend(title=hue, bbox_to_anchor=(1.05, 1), loc='upper left')
    else:
        ax.plot(df[x], df[y], marker='o', linewidth=2, color='#2d6cdf')
    
    ax.set_xlabel(x)
    ax.set_ylabel(y)
    ax.set_title(titulo, fontweight='bold', pad=20)
    ax.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig(archivo, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"    Guardado: {archivo}")


def crear_grafico_torta(df, labels, values, titulo, archivo):
    """Crea un grafico de torta/pie."""
    fig, ax = plt.subplots(figsize=(10, 8))
    colors = sns.color_palette("husl", len(df))
    
    wedges, texts, autotexts = ax.pie(
        df[values], 
        labels=df[labels], 
        autopct='%1.1f%%',
        colors=colors,
        explode=[0.02] * len(df),
        startangle=90
    )
    
    ax.set_title(titulo, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.savefig(archivo, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"    Guardado: {archivo}")


def crear_heatmap(df, x, y, value, titulo, archivo):
    """Crea un mapa de calor."""
    pivot = df.pivot_table(values=value, index=y, columns=x, aggfunc='sum', fill_value=0)
    
    fig, ax = plt.subplots(figsize=(14, 8))
    sns.heatmap(pivot, annot=True, fmt=',.0f', cmap='YlOrRd', ax=ax,
                linewidths=0.5, cbar_kws={'label': value})
    
    ax.set_title(titulo, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.savefig(archivo, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"    Guardado: {archivo}")


def generar_dashboard_html(output_dir):
    """Genera un archivo HTML con todos los graficos como dashboard."""
    graficos = [f for f in os.listdir(output_dir) if f.endswith('.png')]
    
    html = """<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard OLAP - Proyecto Pedidos</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container { max-width: 1400px; margin: 0 auto; }
        h1 { 
            color: white; 
            text-align: center; 
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(600px, 1fr)); 
            gap: 20px; 
        }
        .card { 
            background: white; 
            border-radius: 12px; 
            padding: 20px; 
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        .card:hover { transform: translateY(-5px); }
        .card img { width: 100%; height: auto; border-radius: 8px; }
        .card h3 { 
            color: #333; 
            margin: 10px 0; 
            font-size: 1.1em;
        }
        .footer { 
            text-align: center; 
            color: white; 
            margin-top: 30px;
            opacity: 0.8;
        }
        .stats {
            display: flex;
            justify-content: space-around;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px 40px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            margin: 10px;
        }
        .stat-card h2 { color: #667eea; margin: 0; font-size: 2em; }
        .stat-card p { color: #666; margin: 5px 0 0 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 Dashboard OLAP - Sistema de Pedidos</h1>
        <p style="text-align: center; color: white; margin-bottom: 30px;">
            Análisis de ventas con dimensiones: Tiempo, Producto, Categoría, Cliente, Proveedor, Empleado, Modalidad de Pago, Ubicación
        </p>
        
        <div class="grid">
"""
    
    titulos = {
        'a_top_productos_proveedor.png': '📦 Top Productos por Proveedor',
        'b_pago_por_ciudad.png': '💳 Modalidad de Pago por Ciudad',
        'e_top_vendedores.png': '👔 Mejores Vendedores',
        'resumen_ventas_anual.png': '📈 Tendencia de Ventas Anuales',
        'analisis_iva.png': '🧾 Análisis de IVA (15% vs 0%)',
        'heatmap_vendedor_categoria.png': '🔥 Ventas por Vendedor y Categoría',
        'modalidad_pago_distribucion.png': '💰 Distribución de Modalidades de Pago'
    }
    
    for grafico in sorted(graficos):
        titulo = titulos.get(grafico, grafico.replace('.png', '').replace('_', ' ').title())
        html += f"""
            <div class="card">
                <img src="{grafico}" alt="{titulo}">
                <h3>{titulo}</h3>
            </div>
"""
    
    html += f"""
        </div>
        <div class="footer">
            <p>Generado el {datetime.now().strftime('%d/%m/%Y %H:%M')} | Proyecto OLAP - Azure SQL</p>
        </div>
    </div>
</body>
</html>
"""
    
    html_path = os.path.join(output_dir, 'dashboard.html')
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print(f"\n  Dashboard HTML generado: {html_path}")


def main():
    """Funcion principal que genera todos los graficos."""
    print("=" * 60)
    print("GENERADOR DE GRAFICOS OLAP - PROYECTO PEDIDOS")
    print("=" * 60)
    
    # Configurar estilo
    setup_style()
    
    # Crear directorio de salida
    output_dir = "graficos"
    os.makedirs(output_dir, exist_ok=True)
    print(f"\nDirectorio de salida: ./{output_dir}/")
    
    # Conectar a la base de datos
    print("\n[1/3] Conectando a la base de datos...")
    conn = connect_database()
    if conn is None:
        return
    
    # Ejecutar consultas
    print("\n[2/3] Ejecutando consultas OLAP...")
    dataframes = {}
    for name, sql in QUERIES.items():
        dataframes[name] = fetch_dataframe(conn, name, sql)
    
    conn.close()
    print("  Conexion cerrada.")
    
    # Generar graficos
    print("\n[3/3] Generando graficos...")
    
    # A: Top productos por proveedor
    if not dataframes['a_top_productos_proveedor'].empty:
        df = dataframes['a_top_productos_proveedor']
        df['Label'] = df['Producto'] + '\n(' + df['Proveedor'] + ')'
        crear_grafico_barras_horizontal(
            df, 'Label', 'UnidadesVendidas',
            'Top 10 Productos Más Vendidos por Proveedor',
            f'{output_dir}/a_top_productos_proveedor.png',
            color='#3498db'
        )
    
    # B: Pago por ciudad
    if not dataframes['b_top_pago_ciudad'].empty:
        df = dataframes['b_top_pago_ciudad']
        df['Label'] = df['ModalidadPago'] + ' - ' + df['Ciudad']
        crear_grafico_barras_horizontal(
            df, 'Label', 'MontoTotal',
            'Modalidad de Pago Preferida por Ciudad',
            f'{output_dir}/b_pago_por_ciudad.png',
            color='#27ae60'
        )
    
    # E: Top vendedores
    if not dataframes['e_top_vendedores'].empty:
        crear_grafico_barras_horizontal(
            dataframes['e_top_vendedores'], 'Vendedor', 'MontoTotal',
            'Mejores Vendedores por Monto Total de Ventas',
            f'{output_dir}/e_top_vendedores.png',
            color='#9b59b6'
        )
    
    # Resumen anual
    if not dataframes['resumen_general'].empty:
        crear_grafico_lineas(
            dataframes['resumen_general'], 'Anio', 'TotalVentas',
            'Tendencia de Ventas Totales por Año',
            f'{output_dir}/resumen_ventas_anual.png'
        )
    
    # Analisis IVA
    if not dataframes['analisis_iva'].empty:
        crear_grafico_torta(
            dataframes['analisis_iva'], 'TipoIVA', 'Total',
            'Distribución de Ventas por Tipo de IVA',
            f'{output_dir}/analisis_iva.png'
        )
    
    # Heatmap vendedor vs categoria
    if not dataframes['e_vendedor_categoria_tiempo_ubicacion_modalidad'].empty:
        df = dataframes['e_vendedor_categoria_tiempo_ubicacion_modalidad']
        df_agg = df.groupby(['Vendedor', 'Categoria'])['MontoTotal'].sum().reset_index()
        if len(df_agg) > 0:
            crear_heatmap(
                df_agg, 'Categoria', 'Vendedor', 'MontoTotal',
                'Mapa de Calor: Ventas por Vendedor y Categoría',
                f'{output_dir}/heatmap_vendedor_categoria.png'
            )
    
    # Distribucion modalidades de pago
    if not dataframes['b_pago_tiempo_region'].empty:
        df = dataframes['b_pago_tiempo_region']
        df_modal = df.groupby('ModalidadPago')['MontoTotal'].sum().reset_index()
        crear_grafico_torta(
            df_modal, 'ModalidadPago', 'MontoTotal',
            'Distribución de Ventas por Modalidad de Pago',
            f'{output_dir}/modalidad_pago_distribucion.png'
        )
    
    # Generar dashboard HTML
    generar_dashboard_html(output_dir)
    
    print("\n" + "=" * 60)
    print("PROCESO COMPLETADO")
    print(f"Graficos guardados en: ./{output_dir}/")
    print(f"Dashboard HTML: ./{output_dir}/dashboard.html")
    print("=" * 60)


if __name__ == "__main__":
    main()
