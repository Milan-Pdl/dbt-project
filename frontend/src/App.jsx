import { useEffect, useState } from 'react'
import axios from 'axios'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
  ResponsiveContainer,
  BarChart,
  Bar,
  Legend,
} from 'recharts'

const API_BASE = 'http://localhost:8000/api'

function App() {
  const [dailyData, setDailyData] = useState([])
  const [customerData, setCustomerData] = useState([])
  const [branchData, setBranchData] = useState([])
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [dailyRes, customerRes, branchRes] = await Promise.all([
          axios.get(`${API_BASE}/daily_transaction_summary`),
          axios.get(`${API_BASE}/customer_360`),
          axios.get(`${API_BASE}/branch_performance_summary`),
        ])

        setDailyData(
          [...dailyRes.data].sort((a, b) => String(a.summary_date).localeCompare(String(b.summary_date)))
        )
        setCustomerData(
          [...customerRes.data].sort((a, b) => (b.total_transaction_amount || 0) - (a.total_transaction_amount || 0))
        )
        setBranchData(
          [...branchRes.data].sort((a, b) => (b.total_transaction_amount || 0) - (a.total_transaction_amount || 0))
        )
      } catch (err) {
        setError(err.message || 'Failed to load data')
      } finally {
        setLoading(false)
      }
    }
    fetchData()
  }, [])

  return (
    <div className="app-shell">
      <header>
        <h1>DBT Mart Visualizer</h1>
        <p>FastAPI backend + React frontend showing gold mart data.</p>
      </header>

      {error && <div className="error-banner">{error}</div>}

      {loading ? (
        <div className="loading-message">Loading mart charts…</div>
      ) : (
        <section className="chart-grid">
        <article className="chart-card">
          <h2>Daily Transaction Volume</h2>
          <ResponsiveContainer width="100%" height={320}>
            <LineChart data={dailyData} margin={{ top: 16, right: 24, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="summary_date" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line type="monotone" dataKey="total_transaction_amount" name="Total Amount" stroke="#1976d2" dot={false} />
              <Line type="monotone" dataKey="transaction_count" name="Count" stroke="#ff9800" dot={false} />
            </LineChart>
          </ResponsiveContainer>
        </article>

        <article className="chart-card">
          <h2>Branch Transaction Performance</h2>
          <ResponsiveContainer width="100%" height={320}>
            <BarChart data={branchData.slice(0, 10)} margin={{ top: 16, right: 24, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="branch_name" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="total_transaction_amount" name="Total Amount" fill="#4caf50" />
              <Bar dataKey="total_transaction_count" name="Total Count" fill="#f44336" />
            </BarChart>
          </ResponsiveContainer>
        </article>

        <article className="chart-card wide-card">
          <h2>Top Customers by Transaction Amount</h2>
          <ResponsiveContainer width="100%" height={360}>
            <BarChart data={customerData.slice(0, 10)} layout="vertical" margin={{ top: 16, right: 24, left: 120, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis type="number" />
              <YAxis dataKey="customer_name" type="category" width={150} />
              <Tooltip />
              <Legend />
              <Bar dataKey="total_transaction_amount" name="Total Transaction Amount" fill="#3f51b5" />
            </BarChart>
          </ResponsiveContainer>
        </article>
      </section>
      )}
    </div>
  )
}

export default App
